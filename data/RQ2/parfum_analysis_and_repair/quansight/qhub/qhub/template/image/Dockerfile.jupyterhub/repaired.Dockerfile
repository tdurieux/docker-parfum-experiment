FROM ubuntu:20.04
LABEL MAINTAINER="Quansight"

COPY scripts/install-apt-minimal.sh /opt/scripts/install-apt-minimal.sh
RUN /opt/scripts/install-apt-minimal.sh

COPY scripts/fix-permissions /opt/scripts/fix-permissions

ENV CONDA_VERSION py37_4.10.3
ENV CONDA_SHA256 a1a7285dea0edc430b2bc7951d89bb30a2a1b32026d2a7b02aacaaa95cf69c7c
SHELL ["/bin/bash", "-c"]

ENV PATH="/opt/conda/bin:$PATH:/opt/scripts"

# ============== base install ===============
COPY scripts/install-conda.sh /opt/scripts/install-conda.sh
RUN /opt/scripts/install-conda.sh

# ========== jupyterhub install ===========
COPY jupyterhub/environment.yaml /opt/jupyterhub/environment.yaml
COPY scripts/install-conda-environment.sh /opt/scripts/install-conda-environment.sh
RUN /opt/scripts/install-conda-environment.sh /opt/jupyterhub/environment.yaml 'false'

COPY jupyterhub /opt/jupyterhub
RUN /opt/jupyterhub/postBuild

WORKDIR /srv/jupyterhub

# So we can actually write a db file here
RUN fix-permissions /srv/jupyterhub

CMD ["jupyterhub", "--config", "/usr/local/etc/jupyterhub/jupyterhub_config.py"]