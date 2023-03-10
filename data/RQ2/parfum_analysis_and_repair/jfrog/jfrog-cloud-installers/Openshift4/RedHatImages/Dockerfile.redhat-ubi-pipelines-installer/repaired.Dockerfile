ARG PIPELINES_BASE_VERSION

FROM docker.bintray.io/jfrog/pipelines-installer:${PIPELINES_BASE_VERSION} AS base

# The new image based on registry.access.redhat.com/ubi
FROM registry.access.redhat.com/ubi8/nodejs-10

USER root

LABEL name="JFrog Pipelines Installer" \
      description="JFrog Pipelines Installer image based on the Red Hat Universal Base Image." \
      vendor="JFrog" \
      summary="JFrog Pipelines Installer (Red Hat UBI)" \
      com.jfrog.license_terms="https://jfrog.com/platform/enterprise-plus-eula/"

# Environment needed for Pipelines
ENV JF_PIPELINES_USER=pipelines \
    PIPELINES_USER_ID=1000721117 \
    PIPELINES_VERSION=${PIPELINES_BASE_VERSION} \
    JF_PRODUCT_HOME=/opt/jfrog/pipelines \
    JF_PRODUCT_DATA_INTERNAL=/var/opt/jfrog/pipelines

ENV NODE_PATH /usr/local/lib/node_modules
ENV TMP_DIR /opt/jfrog/pipelines/var/tmp
ENV SRC_DIR /opt/jfrog/pipelines/installer
ENV DEPENDENCIES /opt/jfrog/pipelines/dependencies

# COPY IN PIPELINES FROM BASE IMAGE
COPY --from=base /usr/local/lib /usr/local/lib
COPY --from=base /opt/jfrog/pipelines/var/tmp /opt/jfrog/pipelines/var/tmp
COPY --from=base /opt/jfrog/pipelines /opt/jfrog/pipelines

# Add EULA information to meet the Red Hat container image certification requirements
COPY entplus_EULA.txt /licenses/

RUN mkdir -p /var/opt/jfrog && chmod 0777 /var/opt/jfrog
RUN mkdir p /opt/jfrog/pipelines/var/etc/ && chmod 0777 /opt/jfrog/pipelines/var/etc/

RUN useradd -M -s /usr/sbin/nologin --uid ${PIPELINES_USER_ID} --user-group pipelines && \
    chown -R ${PIPELINES_USER_ID}:${PIPELINES_USER_ID} /opt/jfrog/pipelines /var/opt/jfrog && \
    yum install -y --disableplugin=subscription-manager wget && \
    yum install -y --disableplugin=subscription-manager procps && \
    yum install -y --disableplugin=subscription-manager net-tools && \
    yum install -y --disableplugin=subscription-manager https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum install -y --disableplugin=subscription-manager hostname python36 python3-pip nc && rm -rf /var/cache/yum

RUN yum install -y --disableplugin=subscription-manager http://www6.atomicorp.com/channels/atomic/centos/7/x86_64/RPMS/atomic-release-1.0-21.el7.art.noarch.rpm && \
    yum install -y --disableplugin=subscription-manager http://www6.atomicorp.com/channels/atomic/centos/7/x86_64/RPMS/oniguruma-5.9.5-3.el7.art.x86_64.rpm && \
    yum install -y --disableplugin=subscription-manager http://www6.atomicorp.com/channels/atomic/centos/7/x86_64/RPMS/jq-1.5-1.el7.art.x86_64.rpm && rm -rf /var/cache/yum

RUN wget https://github.com/mikefarah/yq/releases/download/3.4.0/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq

# install psql
RUN yum install -y --disableplugin=subscription-manager https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-8-x86_64/postgresql10-libs-10.14-1PGDG.rhel8.x86_64.rpm && \
    yum install -y --disableplugin=subscription-manager https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-8-x86_64/postgresql10-10.14-1PGDG.rhel8.x86_64.rpm && rm -rf /var/cache/yum

RUN mkdir -p /usr/local/bin && cp -rf /usr/bin/psql /usr/local/bin/psql
USER ${JF_PIPELINES_USER}
WORKDIR /opt/jfrog/pipelines/installer
ENTRYPOINT ["/bin/bash", "execUtil.sh"]