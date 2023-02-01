# MIT License
# Copyright (c) 2017-2021 Nicola Worthington <nicolaw@tfb.net>
# https://github.com/neechbear/trinitycore

# TODO: Setup automatic CI pipeline to make a nightly build and publish to
#       DockerHub.
#
# TODO: Add command_not_found_handle() to intercept tcadmin SOAP commands.

# Intermediate build container can be pruned by listing filtered by image label:
# docker image rm "$(docker image ls --filter "label=org.label-schema.name=nicolaw/trinitycore-intermediate-build" --quiet)"

# https://hub.docker.com/_/debian
FROM debian:buster-20211220-slim AS build
#FROM debian:buster-slim AS build

LABEL author="Nicola Worthington <nicolaw@tfb.net>"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="nicolaw/trinitycore-intermediate-build"

ARG GIT_BRANCH=3.3.5
ARG GIT_REPO=https://github.com/TrinityCore/TrinityCore.git
ENV DEBIAN_FRONTEND noninteractive

# https://github.com/TrinityCore/TrinityCore/blob/master/.travis.yml
# https://github.com/TrinityCore/TrinityCore/blob/master/.circleci/config.yml
# https://github.com/TrinityCore/circle-ci
# https://trinitycore.atlassian.net/wiki/display/tc/Requirements
RUN apt-get -qq -o Dpkg::Use-Pty=0 update \
 && apt-get -qq -o Dpkg::Use-Pty=0 install --no-install-recommends -y \
    p7zip \
    binutils \
    ca-certificates \
    clang \
    cmake \
    curl \
    default-mysql-client \
    default-libmysqlclient-dev \
    g++ \
    gcc \
    git \
    jq \
    make \
    libboost-all-dev \
    libssl-dev \
    libmariadbclient-dev \
    libreadline-dev \
    zlib1g-dev \
    libbz2-dev \
    libncurses-dev \
    xml2 \
 < /dev/null > /dev/null \
 && rm -rf /var/lib/apt/lists/* \
 && update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100 \
 && update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100

RUN git clone --branch ${GIT_BRANCH} --single-branch --depth 1 ${GIT_REPO} /src

# TODO: Add debug options to Dockerfile multistage build debug tag flavour.
#  if [[ "${cmdarg_cfg[debug]}" == true ]]; then
#    # https://github.com/TrinityCore/TrinityCore/blob/master/.travis.yml
#    # https://trinitycore.atlassian.net/wiki/display/tc/Linux+Core+Installation
#    define[WITH_WARNINGS]=1
#    define[WITH_COREDEBUG]=0 # What does this do, and why is it 0 on a debug build?
#    define[CMAKE_BUILD_TYPE]="Debug"
#    define[CMAKE_C_FLAGS]="-Werror"
#    define[CMAKE_CXX_FLAGS]="-Werror"
#    define[CMAKE_C_FLAGS_DEBUG]="-DNDEBUG"
#    define[CMAKE_CXX_FLAGS_DEBUG]="-DNDEBUG"
#  fi
#  if [[ "${define[WITH_WARNINGS]}" == "0" ]]; then
#    extra_cmake_args+=("-Wno-dev")
#  fi

RUN mkdir -pv /build/ /artifacts/
WORKDIR /build
# TODO: Perhaps get some of these values (or augment them) from build args?
RUN cmake ../src -DTOOLS=1 -DWITH_WARNINGS=0 -DCMAKE_INSTALL_PREFIX=/opt/trinitycore -DCONF_DIR=/etc -Wno-dev
RUN make -j$(nproc)
RUN make install

WORKDIR /artifacts

# Install some additional utilitiy helper tools.
COPY ["tcpassword","gettdb","wait-for-it.sh","usr/local/bin/"]
#ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh usr/local/bin/wait-for-it.sh
#ADD https://raw.githubusercontent.com/bells17/wait-for-it-for-busybox/master/wait-for-it.sh usr/local/bin/wait-for-it.sh
ADD https://raw.githubusercontent.com/neechbear/tcadmin/master/tcadmin usr/local/bin/tcadmin
RUN mkdir -pv usr/bin/ && ln -s -t usr/bin/ /bin/env && chmod -v +rx usr/local/bin/*

# Save upstream source Git SHA information that we built form.
RUN git -C /src rev-parse HEAD > .git-rev \
 && git -C /src rev-parse --short HEAD > .git-rev-short

# Copy binaries and example .dist.conf configuration files.
RUN tar -cf - \
    /usr/share/ca-certificates \
    /etc/ca-certificates* \
    /bin/bash \
    /usr/local/bin \
    /usr/bin/mysql \
    /usr/bin/curl \
    /usr/bin/7zr \
    /usr/bin/jq \
    /usr/bin/git \
    /usr/bin/xml2 \
    /opt/trinitycore \
    /etc/*server.conf.dist \
  | tar -C /artifacts/ -xvf -

# Copy SQL source files for "sql" flavour build tag.
ARG FLAVOUR=slim
RUN if [ "x${FLAVOUR}" = "xsql" ] || [ "x${FLAVOUR}" = "xfull" ] ; then \
    tar -cf - /src/sql | tar -C /artifacts/ -xvf - \
 ; fi
#    tar -cf - --exclude=/src/sql/old /src/sql | tar -C /artifacts/ -xvf - \

# Copy all source, some build files for "full" flavour build tag.
RUN if [ "x${FLAVOUR}" = "xfull" ] ; then \
    ln -s -t usr/local/ /src \
 && ln -s -t opt/trinitycore/ /src \
 && ln -s -t opt/trinitycore/ /build \
 && tar -cf - --exclude=**build/dep/** --exclude=**build/src/** /src /build /usr/bin/cmake | tar -C /artifacts/ -xvf - \
 ; fi

# Copy linked libraries and strip symbols from binaries.
RUN ldd opt/trinitycore/bin/* usr/bin/* | grep ' => ' | tr -s '[:blank:]' '\n' | grep '^/' | sort -u | \
    xargs -I % sh -c 'mkdir -pv $(dirname .%); cp -v % .%'
RUN strip opt/trinitycore/bin/*

# Move example .conf.dist configuration files into expected .conf locations.
RUN mv -v etc/authserver.conf.dist etc/authserver.conf \
 && mv -v etc/worldserver.conf.dist etc/worldserver.conf

# Download TDB_full_world SQL dump to populate worldserver database for "sql" and "full" flavour build tags.
RUN if [ "x${FLAVOUR}" = "xsql" ] || [ "x${FLAVOUR}" = "xfull" ] ; then \
    cd src/sql \
 && ../../usr/local/bin/gettdb \
 && rm -fv *.7z \
 && cd ../../ \
 && ln -s src/sql/TDB_full_world_*.sql \
 && ln -s src/sql \
 && ln -s -t opt/trinitycore/ /src/sql \
 ; fi



# https://hub.docker.com/_/busybox
# 1.32.0-glibc appears to be the last version that didn't cause the following symbol error:
# worldserver: symbol lookup error: /lib/x86_64-linux-gnu/librt.so.1: undefined symbol: __clock_nanosleep, version GLIBC_PRIVATE
#FROM busybox:1.34.1-glibc
FROM busybox:1.32.0-glibc
#FROM busybox:stable-glibc

LABEL author="Nicola Worthington <nicolaw@tfb.net>"

ARG FLAVOUR=slim
ARG BUILD_DATE
ARG VCS_REF
ARG BUILD_VERSION
ARG TDB_FULL_URL

# TODO: Replace these labels with the newly adopted standard format instead.