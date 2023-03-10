FROM vasdvp/lighthouse-node-application-base:node16

# Build Args
ARG BUILD_DATE_TIME
ARG BUILD_VERSION
ARG BUILD_NUMBER
ARG BUILD_TOOL

# Static Labels
LABEL org.opencontainers.image.authors="Pivot!" \
      org.opencontainers.image.url="https://github.com/department-of-veterans-affairs/lighthouse-saml-proxy/blob/master/Dockerfile.test" \
      org.opencontainers.image.documentation="https://github.com/department-of-veterans-affairs/lighthouse-saml-proxy/blob/master/test/regression_tests/README.md" \
      org.opencontainers.image.vendor="lighthouse" \
      org.opencontainers.image.title="lighthouse-saml-tests" \
      org.opencontainers.image.source="https://github.com/department-of-veterans-affairs/lighthouse-saml-proxy" \
      org.opencontainers.image.description="SAML Proxy Tests for Lighthouse APIs"

# Dynamic Labels
LABEL org.opencontainers.image.created=${BUILD_DATE_TIME} \
      org.opencontainers.image.version=${BUILD_VERSION} \
      gov.va.build.number=${BUILD_NUMBER} \
      gov.va.build.tool=${BUILD_TOOL}

USER root

WORKDIR /opt/va

COPY --chown=node:node ./test/regression_tests/ .


RUN npm i && npm cache clean --force;

# Install chrome dependencies
# Install chrome dependencies
RUN yum install -y -q wget && rm -rf /var/cache/yum
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
RUN dnf -y install google-chrome-stable_current_x86_64.rpm

USER node

ENTRYPOINT ["./entrypoint_test.sh"]
