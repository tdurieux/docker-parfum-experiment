# dockerfile for hassio addon
# copyright: © 2018 by Nuno Gonçalves
# license: MIT, see LICENSE for more details.

ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

# install keeper
COPY ../install /
RUN /install

# start keeper
CMD ["/opt/keeper/bin/keeper"]

# build arguments
ARG BUILD_ARCH
ARG BUILD_VERSION
ARG BUILD_DATE
ARG BUILD_REF
# labels
LABEL \
    io.hass.name="Keeper" \
    io.hass.description="A service to monitor and maintaining MQTT and HomeAssistant" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Nuno Gonçalves <nunoo_7@hotmail.com>" \
    org.label-schema.description="A service to monitor and maintaining MQTT and HomeAssistant" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Keeper" \
    org.label-schema.schema-version="0.1.2" \
    org.label-schema.url="https://github.com/nragon/keeper" \
    org.label-schema.usage="https://github.com/nragon/keeper/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/nragon/keeper" \
    org.label-schema.vendor="Keeper Hass.io Add-on"