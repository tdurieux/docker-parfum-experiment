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