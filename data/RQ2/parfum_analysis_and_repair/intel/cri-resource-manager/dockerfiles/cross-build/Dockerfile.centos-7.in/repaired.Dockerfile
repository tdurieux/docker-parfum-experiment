# pull in base + a minimal set of useful packages
FROM centos:7 as centos-7-build

ARG GOLANG_VERSION=x.yz
ARG GOLANG_URLDIR=https://dl.google.com/go
ARG GIT_VERSION=2.27.0
ARG GIT_URLDIR=https://github.com/git/git/archive
ARG CREATE_USER="build"
ARG USER_OPTIONS=""
ENV PATH /go/bin:/usr/local/go/bin:$PATH

RUN yum install -y --nogpgcheck rpm-build \
    kernel-devel clang gcc \ clang gcc \
    curl-devel zlib-devel openssl-devel expat-devel \
    make wget && rm -rf /var/cache/yum

# fetch and build go from sources
RUN arch="$(rpm --eval %{_arch})"; \
    case "${arch}" in \
        x86_64) goarch=linux-amd64;; \
        i386) goarch=linux-386;; \
        armhf) goarch=linux-armv6l;; \
        ppc64el) goarch=linux-ppc64le;; \
        s390x) goarch=linux-s390x;; \
    esac; \
    \
    wget $GOLANG_URLDIR/go$GOLANG_VERSION.$goarch.tar.gz -O go.tgz && \
    tar -C /usr/local -xvzf go.tgz && rm go.tgz && \
    \
    export PATH="/usr/local/go/bin:$PATH" && \
    echo "PATH=/usr/local/go/bin:$PATH" > /etc/profile.d/go.sh && \
    go version

# fetch and build a recent git from sources, anything below 1.9.5 is known to not work for us
RUN mkdir /git && cd /git && wget $GIT_URLDIR/v$GIT_VERSION.tar.gz && \
    tar -xvzf v$GIT_VERSION.tar.gz && cd git-$GIT_VERSION && \
    make -j8 NO_TCLTK=1 NO_GETTEXT=1 prefix=/usr all && \
    yum remove -y git && \
    make -j8 NO_TCLTK=1 NO_GETTEXT=1 prefix=/usr install && rm v$GIT_VERSION.tar.gz

RUN [ -n "$CREATE_USER" -a "$CREATE_USER" != "root" ] && \
    useradd -m -s /bin/bash $CREATE_USER $USER_OPTIONS
