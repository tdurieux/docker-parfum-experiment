FROM ubuntu

MAINTAINER The Crossbar.io Project <support@crossbario.com>

# Metadata
ARG BUILD_DATE
ARG AUTOBAHN_JAVA_VERSION
ARG AUTOBAHN_JAVA_VCS_REF

# Metadata labeling
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="AutobahnJava" \
      org.label-schema.description="AutobahnJava toolchain image for Netty with Java 8 SDK, AutobahnJava, Jackson and gradle" \
      org.label-schema.url="http://crossbar.io" \
      org.label-schema.vcs-ref=$AUTOBAHN_JAVA_VCS_REF \
      org.label-schema.vcs-url="https://github.com/crossbario/autobahn-java" \
      org.label-schema.vendor="The Crossbar.io Project" \
      org.label-schema.version=$AUTOBAHN_JAVA_VERSION \
      org.label-schema.schema-version="1.0"

USER root

ENV DEBIAN_FRONTEND noninteractive
ENV GRADLE_VERSION 4.7

WORKDIR /workspace

RUN    apt update \
    && apt install unzip wget openjdk-8-jdk-headless -y \
    && apt clean \
    && rm -rf /var/lib/apt/lists/

RUN    wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip \
    && mkdir /opt/gradle \
    && unzip -d /opt/gradle gradle-${GRADLE_VERSION}-bin.zip \
    && rm gradle-${GRADLE_VERSION}-bin.zip

ENV PATH=$PATH:/opt/gradle/gradle-${GRADLE_VERSION}/bin

COPY ${PWD} /workspace

RUN gradle installDist -PbuildPlatform=netty -PbuildVersion=${AUTOBAHN_JAVA_VERSION}

RUN mkdir -p /autobahn; cp /workspace/demo-gallery/build/install/demo-gallery/lib/* /autobahn; \
    rm /autobahn/demo-gallery*.jar

CMD ["gradle", "installDist", "-PbuildPlatform=netty"]
