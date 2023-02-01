ARG BUILD_FROM=hassioaddons/ubuntu-base:2.2.0
# hadolint ignore=DL3006
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# setup base system
ARG BUILD_ARCH=amd64

RUN apt-get update \
  && apt-get install -y kafkacat mosquitto-clients \
  \
  && ARCH="${BUILD_ARCH}" \
  && if [ "${BUILD_ARCH}" = "aarch64" ]; then ARCH="arm64"; fi \
  \
  && HORIZON_CLI="2.20.0" \
  && HORIZON_URL="http://pkg.bluehorizon.network/linux/ubuntu/pool/main/h/horizon/horizon-cli" \
  && HORIZON_PKG="${HORIZON_URL}_${HORIZON_CLI}~ppa~ubuntu.xenial_${ARCH}.deb" \
  && curl -fsSL -o /tmp/horizon-cli.deb  "${HORIZON_PKG}" \
  && dpkg --install /tmp/horizon-cli.deb \
  && rm -fr \
      /tmp/* \
      /var/{cache,log}/* \
      /var/lib/apt/lists/*

# the pattern we expect to run
ENV HORIZON_PATTERN='{"id":"sdr2msghub","org":"IBM","url":"github.com.open-horizon.examples.sdr2msghub"}'

# Copy root filesystem
COPY rootfs /

CMD ["/usr/bin/run.sh"]

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="sdr2msghub" \
    io.hass.description="Example Horizon-based addon to share SDR audio" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="David C Martin <github@dcmartin.com>" \
    org.label-schema.description="Example Horizon based addon" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="sdr2msghub" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://addons.community" \
    org.label-schema.usage="https://github.com/dcmartin/hassio-addons/sdr2msghub/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/dcmartin/hassio-addons/sdr2msghub" \
    org.label-schema.vendor="DCMARTIN"
