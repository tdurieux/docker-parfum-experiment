FROM buildpack-deps:focal-curl
LABEL maintainer="Manfred Touron <m@42.am> (https://github.com/moul)"

# Install deps
RUN set -x; \
    apt-get update \
 && apt-get install --no-install-recommends -y -q \
        autoconf \
        automake \
        autotools-dev \
        bc \
        build-essential \
        clang \
        curl \
        devscripts \
        gdb \
        git-core \
        libtool \
        llvm \
        multistrap \
        patch \
        software-properties-common \
        wget \
        xz-utils \
        cmake \
        mingw-w64 \
 && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Install OSx cross-tools

#Build arguments
ARG osxcross_repo="tpoechtrager/osxcross"
ARG osxcross_revision="a845375e028d29b447439b0c65dea4a9b4d2b2f6"
ARG darwin_sdk_version="10.10"
ARG darwin_osx_version_min="10.6"
ARG darwin_version="14"
ARG darwin_sdk_url="https://www.dropbox.com/s/yfbesd249w10lpc/MacOSX${darwin_sdk_version}.sdk.tar.xz"

# ENV available in docker image
ENV OSXCROSS_REPO="${osxcross_repo}"                   \
    OSXCROSS_REVISION="${osxcross_revision}"           \
    DARWIN_SDK_VERSION="${darwin_sdk_version}"         \
    DARWIN_VERSION="${darwin_version}"                 \
    DARWIN_OSX_VERSION_MIN="${darwin_osx_version_min}" \
    DARWIN_SDK_URL="${darwin_sdk_url}"

COPY build.patch /tmp/build.patch

RUN mkdir -p "/tmp/osxcross"                                                                             \
 && cd "/tmp/osxcross" \
 && curl -f -sLo osxcross.tar.gz "https://codeload.github.com/${OSXCROSS_REPO}/tar.gz/${OSXCROSS_REVISION}" \
 && tar --strip=1 -xzf osxcross.tar.gz \
 && rm -f osxcross.tar.gz \
 && curl -f -sLo tarballs/MacOSX${DARWIN_SDK_VERSION}.sdk.tar.xz "${DARWIN_SDK_URL}" \
 && patch -p0 < /tmp/build.patch \
 && yes "" | SDK_VERSION="${DARWIN_SDK_VERSION}" OSX_VERSION_MIN="${DARWIN_OSX_VERSION_MIN}" ./build.sh \
 && mv target /usr/osxcross \
 && mv tools /usr/osxcross/ \
 && ln -sf ../tools/osxcross-macports /usr/osxcross/bin/omp \
 && ln -sf ../tools/osxcross-macports /usr/osxcross/bin/osxcross-macports \
 && ln -sf ../tools/osxcross-macports /usr/osxcross/bin/osxcross-mp \
 && rm -rf /tmp/osxcross \
 && rm -rf "/usr/osxcross/SDK/MacOSX${DARWIN_SDK_VERSION}.sdk/usr/share/man"


# Create symlinks for triples and set default CROSS_TRIPLE
ENV DARWIN_TRIPLES=x86_64h-apple-darwin${DARWIN_VERSION},x86_64-apple-darwin${DARWIN_VERSION},i386-apple-darwin${DARWIN_VERSION}  \
    WINDOWS_TRIPLES=i686-w64-mingw32,x86_64-w64-mingw32                                                                           \
    CROSS_TRIPLE=x86_64-linux-gnu

RUN wget -k 'https://raw.githubusercontent.com/multiarch/crossbuild/master/assets/osxcross-wrapper' -O /usr/bin/osxcross-wrapper && \
    chmod ugo+x /usr/bin/osxcross-wrapper
RUN for triple in $(echo ${DARWIN_TRIPLES} | tr "," " "); do                                      \
      mkdir -p /usr/x86_64-linux-gnu/$triple                                                      \
      mkdir -p /usr/$triple/bin;                                                                  \
      for bin in /usr/osxcross/bin/$triple-*; do                                                  \
        ln /usr/bin/osxcross-wrapper /usr/$triple/bin/$(basename $bin | sed "s/$triple-//");      \
      done &&                                                                                     \
      rm -f /usr/$triple/bin/clang*;                                                              \
      ln -s cc /usr/$triple/bin/gcc;                                                              \
      ln -s /usr/osxcross/SDK/MacOSX${DARWIN_SDK_VERSION}.sdk/usr /usr/x86_64-linux-gnu/$triple;  \
    done;                                                                                         \
    for triple in $(echo ${WINDOWS_TRIPLES} | tr "," " "); do                                     \
      mkdir -p /usr/x86_64-linux-gnu/$triple                                                      \
      mkdir -p /usr/$triple/bin;                                                                  \
      for bin in /etc/alternatives/$triple-* /usr/bin/$triple-*; do                               \
        if [ ! -f /usr/$triple/bin/$(basename $bin | sed "s/$triple-//") ]; then                  \
          ln -s $bin /usr/$triple/bin/$(basename $bin | sed "s/$triple-//");                      \
        fi;                                                                                       \
      done;                                                                                       \
      ln -s gcc /usr/$triple/bin/cc;                                                              \
      ln -s /usr/$triple /usr/x86_64-linux-gnu/$triple;                                           \
    done
# we need to use default clang binary to avoid a bug in osxcross that recursively call himself
# with more and more parameters

# Image metadata
ENTRYPOINT ["/usr/bin/crossbuild"]
CMD ["/bin/bash"]
WORKDIR /workdir
RUN wget -k 'https://raw.githubusercontent.com/multiarch/crossbuild/master/assets/crossbuild' -O /usr/bin/crossbuild && \
    chmod ugo+x /usr/bin/crossbuild

# docker build -f Dockerfile.crossbuild -t quay.io/geotrellis/gdal-warp-bindings-crossbuild:amd64-2 .
