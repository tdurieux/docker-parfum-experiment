ARG XRAY_BASE_VERSION
ARG FLUENT_CONF

FROM docker.bintray.io/jfrog/xray-indexer:${XRAY_BASE_VERSION} AS base

# The new image based on registry.access.redhat.com/ubi
FROM registry.access.redhat.com/ubi8

ARG FLUENT_CONF

LABEL name="JFrog Xray Indexer" \
      description="JFrog Xray Indexer image based on the Red Hat Universal Base Image." \
      vendor="JFrog" \
      summary="JFrog Xray Indexer (Red Hat UBI)" \
      com.jfrog.license_terms="https://jfrog.com/xray/eula/"

# Environment needed for Xray
ENV JF_XRAY_USER=xray \
    XRAY_USER_ID=1035 \
    XRAY_VERSION=${XRAY_BASE_VERSION} \
    JF_PRODUCT_HOME=/opt/jfrog/xray \
    JF_PRODUCT_DATA_INTERNAL=/var/opt/jfrog/xray \
    SERVICE_NAME=indexer \
    FLUENT_CONF=${FLUENT_CONF}

COPY --from=base /opt/jfrog/xray /opt/jfrog/xray
COPY --from=base /postgresql-client /postgresql-client

# Add license information to meet the Red Hat container image certification requirements
COPY --from=base /opt/jfrog/xray/app/doc/* /licenses/

RUN mkdir -p /var/opt/jfrog && chmod 0777 /var/opt/jfrog

RUN useradd -s /usr/sbin/nologin --uid 1035 --user-group xray && \
    chown -R 1035:1035 /opt/jfrog/xray /var/opt/jfrog /postgresql-client && \
    yum install -y --disableplugin=subscription-manager wget && \
    yum install -y --disableplugin=subscription-manager procps && \
    yum install -y --disableplugin=subscription-manager net-tools && \
    yum install -y --disableplugin=subscription-manager hostname && \
    yum install -y --disableplugin=subscription-manager sudo gem ruby-devel gcc gcc-c++ make && rm -rf /var/cache/yum
RUN curl -f -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent3.sh | sh

RUN mkdir -p /var/log/td-agent/buffer && \
    chown -R ${JF_XRAY_USER}:${JF_XRAY_USER} /var/log/td-agent && \
    chown -R ${JF_XRAY_USER}:${JF_XRAY_USER} /etc/td-agent

RUN mkdir -p /usr/lib/rpm/redhat/ && \
    touch /usr/lib/rpm/redhat/redhat-hardened-cc1 && \
    touch /usr/lib/rpm/redhat/redhat-hardened-ld && \
    touch /usr/lib/rpm/redhat/redhat-annobin-cc1 && \
    td-agent-gem install fluent-plugin-splunk-enterprise && \
    td-agent-gem install fluent-plugin-datadog


# REMOVE THE DEV TOOLS NEEDED FOR GEM INSTALL NOW..
RUN yum remove -y --disableplugin=subscription-manager gcc gcc-c++ make

USER $JF_XRAY_USER

COPY ${FLUENT_CONF} /etc/td-agent/td-agent.conf

VOLUME /var/opt/jfrog/xray

ENTRYPOINT ["/opt/jfrog/xray/app/bin/wrapper.sh"]
