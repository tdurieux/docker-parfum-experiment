FROM debian:jessie-backports
MAINTAINER gustavo.amigo@gmail.com

RUN apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends -t jessie-backports \
        bash \
        curl \
        git \
        bc \
        openjdk-8-jdk \
        default-jre \
        openssh-client \
        openssl \
        tar; \
    update-alternatives --config java; \
    update-java-alternatives -s java-1.8.0-openjdk-amd64; \
    curl -sL https://deb.nodesource.com/setup_8.x | bash -; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends nodejs

ENV SBT_VERSION 1.1.1
ENV SBT_HOME /usr/local/sbt
ENV PATH ${PATH}:${SBT_HOME}/bin
ENV JAVA_OPTS "-Dquill.macro.log=false -Xmx3G"

# Install sbt
RUN curl -sL "https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.tgz" | gunzip | tar -x -C /usr/local --strip-components=1 && \
    echo -ne "- with sbt $SBT_VERSION\n" >> /root/.built

WORKDIR /app