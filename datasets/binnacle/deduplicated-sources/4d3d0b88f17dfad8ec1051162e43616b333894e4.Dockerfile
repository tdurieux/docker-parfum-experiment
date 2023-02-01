ARG BUILD_FROM
FROM ${BUILD_FROM}

# Copy root filesystem
COPY docker/rootfs/ /
COPY setup.py setup.cfg MANIFEST.in /opt/esphome/
COPY esphome /opt/esphome/esphome

RUN pip2 install --no-cache-dir -e /opt/esphome

# Build arguments
ARG BUILD_VERSION=dev

# Labels
LABEL \
    io.hass.name="ESPHome" \
    io.hass.description="Manage and program ESP8266/ESP32 microcontrollers through YAML configuration files" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION}
