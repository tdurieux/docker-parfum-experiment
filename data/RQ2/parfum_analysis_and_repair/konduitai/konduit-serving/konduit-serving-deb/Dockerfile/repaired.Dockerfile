FROM ubuntu:latest
MAINTAINER Max Pumperla <max@skymind.io>
RUN apt update && apt install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;
ADD konduit /usr/share/konduit
WORKDIR  /usr/share/konduit
RUN ./mvnw -Djavacpp.platform=linux-x86_64 -Dchip=cpu -Pdeb -Ppython clean install -Dmaven.test.skip=true