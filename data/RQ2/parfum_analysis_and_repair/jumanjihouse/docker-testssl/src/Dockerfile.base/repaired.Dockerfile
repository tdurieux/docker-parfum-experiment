FROM alpine:3.12.0

RUN apk --update-cache upgrade && \
    apk add \
      bash \
      bind-tools \
      coreutils \
      'curl>=7.58.0-r0' \
      'ncurses>=6.0_p20170930-r0' \
      procps \
      tzdata \
      && \
    rm -f /var/cache/apk/*

# This variable is set in ci/build.
ARG TARBALL

# Use the statically-compiled version of openssl from
# https://testssl.sh/
RUN cd /tmp/ && \
    curl -f -L -O https://testssl.sh/${TARBALL} && \
    tar xvzf ${TARBALL} && \
    mv bin/openssl.Linux.x86_64.static bin/openssl.Linux.x86_64 && \
    cp -f bin/openssl.Linux.x86_64 /usr/bin/openssl && \
    rm -f ${TARBALL} && \
    rm -fr bin/

# Install RFC mapping file.
RUN curl -f -L -o /etc/mapping-rfc.txt https://testssl.sh/mapping-rfc.txt

ENTRYPOINT ["/testssl.sh"]
CMD ["--help"]

# testssl.sh creates files here, so use a volume to
# allow to run container with read-only root filesystem.
VOLUME /tmp
