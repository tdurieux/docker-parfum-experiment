ARG TAG="development"
ARG PROJECT="coffea-casa"
ARG HUB="hub.opensciencegrid.org"
ARG NAME="${PROJECT}}/cc-centos7"
FROM ${HUB}/${NAME}:${TAG}

USER root
LABEL maintainer="Oksana Shadura <ksu.shadura@gmail.com>"
# Worker image
# Tag
ARG TAG
ARG PROJECT
ARG HUB
ARG WORKER_IMAGE="${HUB}/${PROJECT}/cc-centos7-skyhook"
# Try to see if CEPH_CONF works (https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/1.2.3/html/ceph_configuration_guide/configuration_file_structure)
ARG CEPH_DIR="/opt/ceph"
ARG CEPH_CONF=$CEPH_DIR"/ceph.conf"

# Hack for GH Actions
ARG GITHUB_ACTIONS="false"

# Configure environment
ENV CEPH_DIR=$CEPH_DIR
ENV CEPH_CONF=$CEPH_CONF
ENV TAG=$TAG
ENV WORKER_IMAGE=$WORKER_IMAGE

USER root
RUN yum -y update \
 && yum -y install \
    libradospp-dev librados2 rados-objclass-dev python3-rados ceph ceph-mon ceph-osd ceph-mgr ceph-mds ceph-common && rm -rf /var/cache/yum
# Preparing directories for Dask conf files, patches and job spool directory for HTCondor
RUN mkdir -p ${CEPH_DIR} && chown -R "${NB_USER}:${NB_GID}" ${CEPH_DIR}

USER ${NB_UID}
COPY skyhook/build-skyhook.sh /tmp/
COPY skyhook/.coffea.toml $HOME/

RUN cd /tmp && \
    git clone \
        --branch arrow-master \
        --depth=1 \
        https://github.com/uccross/skyhookdm-arrow && \
        ./build-skyhook.sh

# Skyhook setup: Ceph configuration and Keyring
COPY ceph/ceph.conf ceph/keyring ${CEPH_DIR}/

USER root
# Cleanup
RUN rm -rf /tmp/* \
    && rm -rf $HOME/.cache/.pip/* \
    && mamba clean -tipsy \
    && jupyter lab clean \
    && jlpm cache clean \
    && npm cache clean --force \
    && find ${CONDA_DIR} -type f -name '*.a' -delete \
    && find ${CONDA_DIR} -type f -name '*.pyc' -delete \
    && find ${CONDA_DIR} -type f -name '*.js.map' -delete \
    && (find ${CONDA_DIR}/lib/python*/site-packages/bokeh/server/static -type f,l -name '*.js' -not -name '*.min.js' -delete || echo "no bokeh static files to cleanup") \
    && rm -rf ${CONDA_DIR}/pkgs

# Fix permissions for Dask/Ceph config files
RUN chown -R "${NB_USER}:${NB_GID}" ${CEPH_DIR}/keyring ${CEPH_DIR}/ceph.conf

# Switch back to cms-jovyan to avoid accidental container runs as root
USER ${NB_UID}
WORKDIR $HOME
ENTRYPOINT ["tini", "-g", "--", "/usr/local/bin/prepare-env.sh"]

# Extra packages to be installed (apt, pip, conda) and commands to be executed
# Use bash login shell for entrypoint in order
# to automatically source user's .bashrc
CMD ["start-notebook.sh"]
