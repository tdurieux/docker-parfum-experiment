FROM ubuntu:16.04
MAINTAINER Evgeniy Zuykin <eugenzuy@gmail.com>
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository -y ppa:cwchien/gradle && \
    apt-get update -y && \
    apt-get install --no-install-recommends -y openjdk-8-jdk gradle-3.5.1 && \
    rm -rf /var/lib/apt/lists/*

ENV SOLUTION_CODE_ENTRYPOINT=Main.kt
ENV COMPILED_FILE_PATH=/opt/client/build/libs/kotlinStrategy.jar
ENV SOLUTION_CODE_PATH=/opt/client/src/main/kotlin/
ENV COMPILATION_COMMAND='gradle build -q 2>&1'
ENV RUN_COMMAND='java -jar $MOUNT_POINT'

COPY build.gradle ./
RUN mkdir -p src/main/kotlin && gradle build -q && \
    rm -rf build
