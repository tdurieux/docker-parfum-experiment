#
# Docker file for AppStream Generator CI tests
#
FROM debian:unstable

# prepare
RUN apt-get update -qq

# install build essentials
RUN apt-get install -yq git gcc ldc
RUN echo "deb http://deb.debian.org/debian experimental main" >> /etc/apt/sources.list
RUN apt-get update -qq
RUN apt-get -t experimental install -yq gdc-9

# install dependencies used by both appstream and appstream-generator
RUN apt-get install -yq --no-install-recommends \
    meson \
    gettext \
    gobject-introspection \
    gtk-doc-tools \
    libgirepository1.0-dev \
    libglib2.0-dev \
    libstemmer-dev \
    libxml2-dev \
    libyaml-dev \
    gperf

# install dependencies only for appstream-generator
RUN apt-get install -yq --no-install-recommends \
    gir-to-d \
    libglibd-2.0-dev \
    libcurl4-gnutls-dev \
    liblmdb-dev \
    libarchive-dev \
    libgdk-pixbuf2.0-dev \
    librsvg2-dev \
    libfontconfig1-dev \
    libpango1.0-dev

# Misc
RUN apt-get install -yq --no-install-recommends curl gnupg

# Install dscanner
RUN mkdir -p /usr/local/bin/
RUN curl -L https://github.com/dlang-community/D-Scanner/releases/download/v0.5.11/dscanner-v0.5.11-linux-x86_64.tar.gz -o /tmp/dscanner.tar.gz
RUN tar -xzf /tmp/dscanner.tar.gz -C /usr/local/bin/
RUN rm /tmp/dscanner.tar.gz
RUN dscanner --version

# JavaScript stuff
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq
RUN apt-get install -yq --no-install-recommends nodejs yarn

# build & install the current Git snapshot of AppStream
RUN mkdir /build-tmp

RUN cd /build-tmp && \
    git clone --depth=20 https://github.com/ximion/appstream.git
RUN mkdir /build-tmp/appstream/build
RUN cd /build-tmp/appstream/build && \
    meson --prefix=/usr -Dmaintainer=true -Dapt-support=true ..
RUN cd /build-tmp/appstream/build && \
    ninja && ninja install

RUN rm -rf /build-tmp

# finish
RUN mkdir /build
WORKDIR /build
