#参考：https://hub.docker.com/r/jacekmarchwicki/android/dockerfile
#此方式已经失效，参考：https://launchpad.net/~webupd8team/+archive/ubuntu/java

FROM ubuntu:18.04

MAINTAINER 792793182@qq.com

# Android SDK Tools下载地址：https://developer.android.google.cn/studio
RUN rm /etc/apt/sources.list && \
    echo "\
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse\n\
deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse\n\
deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse\n\
deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse\n\
deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse"\
>> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y curl unzip software-properties-common && \
    add-apt-repository -y ppa:webupd8team/java && \
    (echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections) && \
    apt-get update && \
    apt-get install --no-install-recommends -y oracle-java8-installer && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir -p /usr/local/share/android-sdk && \
    cd /usr/local/share/android-sdk && \
    curl -f -LO https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && \
    unzip sdk-tools-linux-4333796.zip && \
    rm sdk-tools-linux-4333796.zip && \
    cd tools/bin && \
    echo y | ./sdkmanager "platforms;android-28" && \
    echo y | ./sdkmanager "platform-tools" && \
    echo y | ./sdkmanager "build-tools;28.0.3"

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV ANDROID_HOME /usr/local/share/android-sdk
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/build-tools/28.0.3
ENV LANG C.UTF-8

CMD [ "bash" ]
