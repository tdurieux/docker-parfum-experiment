FROM alpine:3.10 as base

ENV MANIFEST_TOOL_VERSION 1.0.2

RUN apk add --no-cache curl && \
  curl -f -sSLo /bin/manifest-tool https://github.com/estesp/manifest-tool/releases/download/v${MANIFEST_TOOL_VERSION}/manifest-tool-linux-amd64 && \
  chmod +x /bin/manifest-tool

FROM plugins/base:multiarch

LABEL maintainer="Drone.IO Community <drone-dev@googlegroups.com>" \
  org.label-schema.name="Drone Manifest" \
  org.label-schema.vendor="Drone.IO Community" \
  org.label-schema.schema-version="1.0"

COPY --from=base /bin/manifest-tool /bin/

ADD release/linux/amd64/drone-manifest /bin/
ENTRYPOINT ["/bin/drone-manifest"]
