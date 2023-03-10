FROM centos:7

ENV ARCH=x86_64 DIST=centos7

# inherited by build scripts
ARG VERBOSE=0

RUN yum install -y centos-release-scl && \
    yum install -y devtoolset-8 \
        wget make gnupg zip git subversion glib2-devel automake libtool patch zlib-devel cairo-devel openssl-devel curl-devel \
        fuse-devel vim-common zlib-devel desktop-file-utils fuse fuse-libs gtest-devel \
        libXft-devel librsvg2-devel curl libffi-devel gettext-devel file python2 bzip2 && rm -rf /var/cache/yum

COPY /entrypoint-centos.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
SHELL ["/entrypoint.sh", "bash", "-c"]

RUN wget https://artifacts.assassinate-you.net/prebuilt-cmake/cmake-v3.19.1-centos7-x86_64.tar.gz -O- | tar xz --strip-components=1 -C/usr/local

# pcre >= 8.40 required by glib 2.56
# however, we can just use the latest version, which is 8.44 as of Dec 2020
ARG PCRE_VERSION=8.40
COPY build-pcre.sh /
RUN bash -x /build-pcre.sh

# set up PKG_CONFIG_PATH to ensure that deps in /deps have precedence
# also, pcre is a dep of glib
ENV PKG_CONFIG_PATH=/deps/lib/pkgconfig:/deps/share/pkgconfig

ARG GLIB_VERSION=2.56.0
COPY build-glib.sh /
RUN bash -x /build-glib.sh

ARG GIT_VERSION=2.29.2
COPY build-git.sh /
RUN bash -x /build-git.sh

ARG ZSYNC_VERSION=0.6.2
COPY build-zsync.sh /
RUN bash -x /build-zsync.sh

# create unprivileged user for non-build-script use of this image
# build-in-docker.sh will likely not use this one, as it enforces the caller's uid inside the container
RUN useradd --system build
USER build
