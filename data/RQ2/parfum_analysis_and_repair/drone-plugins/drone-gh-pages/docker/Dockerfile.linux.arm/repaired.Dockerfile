FROM plugins/base:linux-arm

LABEL maintainer="Drone.IO Community <drone-dev@googlegroups.com>" \
  org.label-schema.name="Drone GitHub Pages" \
  org.label-schema.vendor="Drone.IO Community" \
  org.label-schema.schema-version="1.0"

RUN apk add --no-cache git openssh curl rsync perl

ADD release/linux/arm/drone-gh-pages /bin/
ENTRYPOINT ["/bin/drone-gh-pages"]