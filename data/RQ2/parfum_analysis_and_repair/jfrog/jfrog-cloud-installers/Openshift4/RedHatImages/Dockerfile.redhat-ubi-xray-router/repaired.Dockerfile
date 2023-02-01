ARG ROUTER_BASE_VERSION

FROM docker.bintray.io/jfrog/router:${ROUTER_BASE_VERSION} AS base

# The new image based on registry.access.redhat.com/ubi
FROM registry.access.redhat.com/ubi8

LABEL name="JFrog Xray Router" \
      description="JFrog Xray Router image based on the Red Hat Universal Base Image." \
      vendor="JFrog" \
      summary="JFrog Xray Router (Red Hat UBI)" \
      com.jfrog.license_terms="https://jfrog.com/xray/eula/"

# Environment needed for Router
ENV JF_ROUTER_USER=router \
    ROUTER_USER_ID=1000721035 \
    ROUTER_VERSION=${ROUTER_BASE_VERSION} \
    JF_PRODUCT_HOME=/opt/jfrog/router \
    JF_PRODUCT_DATA_INTERNAL=/var/opt/jfrog/router \
    SERVICE_NAME=router

COPY --from=base /opt/jfrog/router /opt/jfrog/router
COPY --from=base /var/opt/jfrog/router /var/opt/jfrog/router

# Add license information to meet the Red Hat container image certification requirements
COPY --from=base /opt/jfrog/router/app/doc/* /licenses/

RUN mkdir -p /var/opt/jfrog && chmod 0777 /var/opt/jfrog

RUN useradd -M -s /usr/sbin/nologin --uid ${ROUTER_USER_ID} --user-group router && \
    chown -R ${ROUTER_USER_ID}:${ROUTER_USER_ID} /opt/jfrog/router /var/opt/jfrog && \
    yum install -y --disableplugin=subscription-manager wget && \
    yum install -y --disableplugin=subscription-manager procps && \
    yum install -y --disableplugin=subscription-manager net-tools && \
    yum install -y --disableplugin=subscription-manager hostname && rm -rf /var/cache/yum

USER router

VOLUME /var/opt/jfrog/router

ENTRYPOINT ["/opt/jfrog/router/app/bin/entrypoint-router.sh"]
