FROM alpine:3.12

ENV JAVA_HOME="/usr/lib/jvm/default-jvm/"

RUN echo -e "https://mirrors.ustc.edu.cn/alpine/v3.12/main\nhttps://mirrors.ustc.edu.cn/alpine/v3.12/community" > /etc/apk/repositories; \
    apk add --no-cache openjdk11

# Has to be set explictly to find binaries
ENV PATH=$PATH:${JAVA_HOME}/bin

ENV GRADLE_VERSION 6.6

# get gradle and supporting libs
RUN apk -U add --no-cache curl; \
    curl -f https://downloads.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip > gradle.zip; \
    unzip gradle.zip; \
    rm gradle.zip; \
    apk del curl; \
    apk update && apk add --no-cache libstdc++ && rm -rf /var/cache/apk/* && apk add --no-cache --update ttf-dejavu fontconfig

COPY simsun.ttf /usr/share/fonts/simsun/simsun.ttf

ENV PATH=${PATH}:/gradle-${GRADLE_VERSION}/bin
