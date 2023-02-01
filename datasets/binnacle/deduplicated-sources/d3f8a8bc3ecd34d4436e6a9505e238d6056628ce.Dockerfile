FROM ubuntu:14.04

ENV http_proxy ${http_proxy:-}
ENV https_proxy ${https_proxy:-}
ENV no_proxy ${no_proxy:-}
ENV OUT_DIR_COMMON_BASE /temp/out/dist
ENV USER root

RUN apt-get -qq update
RUN apt-get -qqy upgrade

RUN echo "dash dash/sh boolean false" | debconf-set-selections && \
    dpkg-reconfigure -p critical dash

# install all of the tools and libraries that we need.
RUN apt-get update && \
    apt-get install -y bc bison bsdmainutils build-essential curl \
        flex g++-multilib gcc-multilib git gnupg gperf lib32ncurses5-dev \
        lib32readline-gplv2-dev lib32z1-dev libesd0-dev libncurses5-dev \
        libsdl1.2-dev libwxgtk2.8-dev libxml2-utils lzop \
        openjdk-7-jdk \
        pngcrush schedtool xsltproc zip zlib1g-dev

ADD https://commondatastorage.googleapis.com/git-repo-downloads/repo /usr/local/bin/
RUN chmod 755 /usr/local/bin/*

RUN apt-get update && apt-get install -y software-properties-common python-software-properties

# We need this because of this https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/
# Here is solution https://engineeringblog.yelp.com/2016/01/dumb-init-an-init-for-docker.html
RUN curl --create-dirs -sSLo /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64
RUN chmod +x /usr/local/bin/dumb-init

# Extras that android-x86.org and android-ia need
RUN apt-get update && apt-get install -y gettext python-libxml2 yasm bc
RUN apt-get update && apt-get install -y squashfs-tools genisoimage dosfstools mtools
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# setting up CCACHE
RUN echo "export USE_CCACHE=1" >> /etc/profile.d/android
ENV USE_CCACHE 1
ENV CCACHE_DIR /ccache

COPY build.sh /script/build.sh
RUN chmod 755 /script/build.sh

WORKDIR /android-repo

CMD ["/usr/local/bin/dumb-init", "--", "/script/build.sh"]