FROM openjdk:8-jre-stretch


ARG VERSION=0.7.3


ENV LANG C.UTF-8

ADD https://github.com/syvaidya/openstego/releases/download/openstego-${VERSION}/openstego-${VERSION}.zip /tmp/
RUN unzip /tmp/openstego-${VERSION}.zip
RUN mv openstego-${VERSION} openstego

RUN useradd -ms /bin/bash openstego


USER openstego
WORKDIR /home/openstego