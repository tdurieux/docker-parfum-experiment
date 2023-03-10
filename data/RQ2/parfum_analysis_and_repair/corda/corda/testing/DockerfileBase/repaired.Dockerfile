FROM ubuntu:18.04
ENV GRADLE_USER_HOME=/tmp/gradle
RUN mkdir /tmp/gradle && mkdir -p /home/root/.m2/repository

RUN apt-get update && apt-get install --no-install-recommends -y curl libatomic1 && \
    curl -f -O https://cdn.azul.com/zulu/bin/zulu8.40.0.25-ca-jdk8.0.222-linux_amd64.deb && \
    apt-get install --no-install-recommends -y java-common && apt install --no-install-recommends -y ./zulu8.40.0.25-ca-jdk8.0.222-linux_amd64.deb && \
    apt-get clean && \
    rm -f zulu8.40.0.25-ca-jdk8.0.222-linux_amd64.deb && \
    curl -f -O https://cdn.azul.com/zulu/bin/zulu8.40.0.25-ca-fx-jdk8.0.222-linux_x64.tar.gz && \
    mv /zulu8.40.0.25-ca-fx-jdk8.0.222-linux_x64.tar.gz /usr/lib/jvm/ && \
    cd /usr/lib/jvm/ && \
    tar -zxvf zulu8.40.0.25-ca-fx-jdk8.0.222-linux_x64.tar.gz && \
    rm -rf zulu-8-amd64 && \
    mv zulu8.40.0.25-ca-fx-jdk8.0.222-linux_x64 zulu-8-amd64 && \
    rm -f zulu8.40.0.25-ca-fx-jdk8.0.222-linux_x64.tar.gz && \
    cd / && mkdir -p /tmp/source && rm -rf /var/lib/apt/lists/*;


