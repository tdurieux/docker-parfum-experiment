ARG PIPELINES_BASE_VERSION

FROM docker.bintray.io/jfrog/pipelines-vault-init:${PIPELINES_BASE_VERSION} AS base

# The new image based on registry.access.redhat.com/ubi
FROM registry.access.redhat.com/ubi8/go-toolset

USER root

LABEL name="JFrog Pipelines Vault Init" \
      description="JFrog Pipelines Vault Init image based on the Red Hat Universal Base Image." \
      vendor="JFrog" \
      summary="JFrog Pipelines Vault Init (Red Hat UBI)" \
      com.jfrog.license_terms="https://jfrog.com/platform/enterprise-plus-eula/"

# Environment needed for Pipelines
ENV JF_PIPELINES_USER=vault \
    PIPELINES_USER_ID=1000721117 \
    PIPELINES_VERSION=${PIPELINES_BASE_VERSION} \
    JF_PRODUCT_HOME=/opt/jfrog/pipelines \
    JF_PRODUCT_DATA_INTERNAL=/var/opt/jfrog/pipelines \
    SERVICE_NAME=vault-init

# COPY IN PIPELINES FROM BASE IMAGE
COPY --from=base /vault-init /opt/jfrog/pipelines/vault-init

# Add EULA information to meet the Red Hat container image certification requirements
COPY entplus_EULA.txt /licenses/

RUN mkdir -p /var/opt/jfrog && chmod 0777 /var/opt/jfrog
RUN useradd -M -s /usr/sbin/nologin --uid ${PIPELINES_USER_ID} --user-group ${JF_PIPELINES_USER} && \
    chown -R ${PIPELINES_USER_ID}:${PIPELINES_USER_ID} /opt/jfrog/pipelines /var/opt/jfrog && \
    yum install -y --disableplugin=subscription-manager wget && \
    yum install -y --disableplugin=subscription-manager procps && \
    yum install -y --disableplugin=subscription-manager net-tools && \
    yum install -y --disableplugin=subscription-manager hostname && rm -rf /var/cache/yum

USER ${JF_PIPELINES_USER}
WORKDIR /opt/jfrog/pipelines
ENTRYPOINT ["/opt/jfrog/pipelines/vault-init"]
