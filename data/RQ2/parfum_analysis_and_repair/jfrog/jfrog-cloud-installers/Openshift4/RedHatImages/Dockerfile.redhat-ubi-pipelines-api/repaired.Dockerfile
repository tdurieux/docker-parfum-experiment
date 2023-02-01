ARG PIPELINES_BASE_VERSION

FROM docker.bintray.io/jfrog/pipelines-api:${PIPELINES_BASE_VERSION} AS base

# The new image based on registry.access.redhat.com/ubi
FROM registry.access.redhat.com/ubi8/nodejs-10

USER root

LABEL name="JFrog Pipelines API" \
      description="JFrog Pipelines API image based on the Red Hat Universal Base Image." \
      vendor="JFrog" \
      summary="JFrog Pipelines API (Red Hat UBI)" \
      com.jfrog.license_terms="https://jfrog.com/platform/enterprise-plus-eula/"

# Environment needed for Pipelines
ENV JF_PIPELINES_USER=pipelines \
    PIPELINES_USER_ID=1000721117 \
    PIPELINES_VERSION=${PIPELINES_BASE_VERSION} \
    JF_PRODUCT_HOME=/opt/jfrog/pipelines \
    JF_PRODUCT_DATA_INTERNAL=/var/opt/jfrog/pipelines \
    SERVICE_NAME=api \
    APP_HOME_DIR=/opt/jfrog/pipelines/app/api \
    LOG_DIR=/opt/jfrog/pipelines/var/log

ENV LOG_DIR=/opt/jfrog/pipelines/var/log
ENV NODE_PATH=/opt/jfrog/pipelines/app/node_modules
ENV API_BIN_DIR /opt/jfrog/pipelines/app/api/bin

# COPY IN PIPELINES FROM BASE IMAGE
COPY --from=base /opt/jfrog/pipelines/app/api /opt/jfrog/pipelines/app/api

# Add EULA information to meet the Red Hat container image certification requirements
COPY entplus_EULA.txt /licenses/

RUN mkdir -p /var/opt/jfrog && chmod 0777 /var/opt/jfrog

RUN useradd -M -s /usr/sbin/nologin --uid ${PIPELINES_USER_ID} --user-group pipelines && \
    chown -R ${PIPELINES_USER_ID}:${PIPELINES_USER_ID} /opt/jfrog/pipelines /var/opt/jfrog && \
    yum install -y --disableplugin=subscription-manager wget && \
    yum install -y --disableplugin=subscription-manager procps && \
    yum install -y --disableplugin=subscription-manager net-tools && \
    yum install -y --disableplugin=subscription-manager hostname && rm -rf /var/cache/yum

RUN mkdir -p /opt/jfrog/pipelines/var/tmp
RUN mkdir -p $LOG_DIR
USER ${JF_PIPELINES_USER}
WORKDIR /opt/jfrog/pipelines/app/api
CMD ["node","api.app.js"]
EXPOSE 30000