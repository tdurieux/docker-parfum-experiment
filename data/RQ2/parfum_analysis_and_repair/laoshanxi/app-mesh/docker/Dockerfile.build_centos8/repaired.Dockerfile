FROM centos:8

COPY autogen.sh go.* /opt/

USER root

RUN cd /opt/ && sh autogen.sh && rm -rf /opt/*