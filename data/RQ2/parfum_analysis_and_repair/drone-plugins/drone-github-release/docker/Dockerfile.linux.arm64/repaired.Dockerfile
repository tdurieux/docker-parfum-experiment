FROM plugins/base:multiarch@sha256:4304d200969c807d1ed171f75ca8be5b5db050051fefde1c6de93618bead4190

LABEL maintainer="Drone.IO Community <drone-dev@googlegroups.com>" \
  org.label-schema.name="Drone GitHub Release" \
  org.label-schema.vendor="Drone.IO Community" \
  org.label-schema.schema-version="1.0"

ADD release/linux/arm64/drone-github-release /bin/
ENTRYPOINT [ "/bin/drone-github-release" ]