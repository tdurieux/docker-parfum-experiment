FROM sc4h/alpine-s6overlay:v2-3.15

ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

ENV \
  PATH="/app/sstv:${PATH}" \
  APP_CONFIG="/config/config.yml" \
  APP_LOG="/config/activity.log" \
  APP_VERBOSITY="0" \
  APP_SSDP="true"

# Deps
RUN apk --update --no-cache add \
    ffmpeg

# Binary
COPY ["dist/sstv_${TARGETOS}_${TARGETARCH}${TARGETVARIANT:+_7}/sstv", "/app/sstv/sstv"]

# Add root files
COPY ["docker/run", "/etc/services.d/sstv/run"]

# Volume
VOLUME ["/config"]

# Port
EXPOSE 1411