FROM ubuntu:16.04

ARG uid
ARG gid

ENV JRUBY_VERSION="9.1.13.0"

RUN groupadd -g $gid builder && useradd -m -u $uid -g $gid builder

RUN mkdir -p /mnt/gradle-cache && chown -R builder:builder /mnt/gradle-cache

RUN apt-get update && \
    apt-get install -y curl software-properties-common gawk \
    openjdk-8-jdk-headless build-essential git unzip debhelper

USER builder

RUN cd ~ && \
    gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && \
    curl -L https://get.rvm.io | bash -s stable

RUN ~/.rvm/bin/rvm install jruby-$JRUBY_VERSION --binary --skip-gemsets && \
    ~/.rvm/bin/rvm jruby-$JRUBY_VERSION do jgem install jruby-openssl jruby-launcher \
    gem-wrappers rubygems-bundler rake:12.0.0 rvm jruby-jars:$JRUBY_VERSION bundler:1.14.6 warbler:2.0.4 bundler-audit && \
    mkdir -p /var/tmp/xroad

WORKDIR /mnt

ENV GRADLE_USER_HOME /mnt/gradle-cache
