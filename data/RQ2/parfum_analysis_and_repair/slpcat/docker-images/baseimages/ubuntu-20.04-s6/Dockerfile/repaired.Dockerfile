FROM ubuntu:20.04
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TZ="Asia/Shanghai"

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list

RUN apt-get update && apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Set timezone and locales
RUN \
    echo "${TZ}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -yq apt-utils dialog tzdata \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales && rm -rf /var/lib/apt/lists/*;

# Install required packages
RUN \
    apt-get dist-upgrade -y && \
    apt-get install --no-install-recommends -y wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

ARG TARGETARCH
ARG S6_VERSION=v2.2.0.3
##
## ROOTFS
##

# root filesystem
#COPY rootfs /

# s6 overlay
COPY install_s6.sh /tmp

# Install s6-overlay
RUN /tmp/install_s6.sh

##
## INIT
##

ENTRYPOINT [ "/init" ]
