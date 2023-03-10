{{#amd64}}
FROM openjdk:8-jre-stretch
{{/amd64}}

{{#arm32v6}}
FROM balenalib/raspberry-pi-debian-openjdk:8-20190511
{{/arm32v6}}

ARG VERSION=0.7.3

{{#cross}}
RUN [ "cross-build-start" ]
{{/cross}}

ENV LANG C.UTF-8

ADD https://github.com/syvaidya/openstego/releases/download/openstego-${VERSION}/openstego-${VERSION}.zip /tmp/
RUN unzip /tmp/openstego-${VERSION}.zip
RUN mv openstego-${VERSION} openstego

RUN useradd -ms /bin/bash openstego

{{#cross}}
RUN [ "cross-build-end" ]
{{/cross}}

USER openstego
WORKDIR /home/openstego