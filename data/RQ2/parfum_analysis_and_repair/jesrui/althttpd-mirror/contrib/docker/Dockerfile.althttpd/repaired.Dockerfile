########################################################################
# Builds a static althttpd binary from the latest trunk source code.
# Optional --build-arg entries:
#    repoUrl=source repo URL (default=canonical tree)
#    version=tag or version to pull (default=trunk)
#    cachebust=an arbitrary value to invalidate docker's cache
########################################################################

# ARG order: https://stackoverflow.com/a/56748289
ARG repoUrl=https://sqlite.org/althttpd
ARG version=trunk
# --build-arg cachebust=x is a cache buster :/
ARG cachebust=0
FROM    alpine:edge

RUN apk update && apk upgrade                  \
    && apk add --no-cache                      \
      curl gcc make musl-dev               \
      openssl-dev zlib-dev openssl-libs-static \
      zlib-static
ARG repoUrl
ARG version
ARG cachebust
RUN curl -f \
      "${repoUrl}/tarball/althttpd-src.tar.gz?name=althttpd-src&uuid=${version}" \
      -o althttpd-src.tar.gz \
      && tar xf althttpd-src.tar.gz \
      && cd althttpd-src \
      && make static-althttpd static-althttpsd && rm althttpd-src.tar.gz
