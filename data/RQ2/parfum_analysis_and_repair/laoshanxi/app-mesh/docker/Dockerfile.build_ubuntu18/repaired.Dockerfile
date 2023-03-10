FROM ubuntu:18.04

COPY autogen.sh go.* /opt/

USER root

RUN cd /opt/ && sh autogen.sh && rm -rf /opt/* && apt-get clean