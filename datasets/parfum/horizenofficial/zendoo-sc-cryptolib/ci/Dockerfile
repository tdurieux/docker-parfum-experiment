FROM ubuntu:18.04

MAINTAINER infrastructure@zensystem.io

SHELL ["/bin/bash", "-c"]

COPY entrypoint.sh entrypoint_setup_gpg.sh /usr/local/bin/

# Get Ubuntu packages
RUN set -eux && export GOSU_VERSION=1.12 && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends build-essential ca-certificates curl dirmngr \
       gcc-mingw-w64-x86-64 gnupg2 gnupg1-curl wget libssl-dev pkg-config jq ; \
# save list of currently installed packages for later so we can clean up
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates wget; \
    if ! command -v gpg; then \
      apt-get install -y --no-install-recommends gnupg2 dirmngr; \
    elif gpg --version | grep -q '^gpg (GnuPG) 1\.'; then \
# "This package provides support for HKPS keyservers." (GnuPG 1.x only)
      apt-get install -y --no-install-recommends gnupg-curl; \
    fi; \
    rm -rf /var/lib/apt/lists/*; \
    \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
    \
# verify the signature
    export GNUPGHOME="$(mktemp -d)"; \
    ( gpg2 --batch --keyserver hkps://keys.openpgp.org --keyserver-options timeout=15 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 || \
      gpg2 --batch --keyserver keyserver.ubuntu.com --keyserver-options timeout=15 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 || \
      gpg2 --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --keyserver-options timeout=15 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 || \
      gpg2 --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --keyserver-options timeout=15 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 || \
      gpg2 --batch --keyserver hkp://pgp.mit.edu:80 --keyserver-options timeout=15 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 ) \
    && gpg2 --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && command -v gpgconf && gpgconf --kill all || :; \
    rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
    \
# clean up fetch dependencies
    apt-mark auto '.*' > /dev/null; \
    [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    \
    chmod +x /usr/local/bin/gosu; \
# verify that the binary works
    gosu --version; \
    gosu nobody true \
    && chmod +x /usr/local/bin/{entrypoint.sh,entrypoint_setup_gpg.sh} \
    && apt-get -y clean \
    && apt-get -y autoclean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
