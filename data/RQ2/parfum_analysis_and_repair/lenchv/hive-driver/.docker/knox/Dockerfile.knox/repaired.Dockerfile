FROM lenchv/base-hive:2.3.6

WORKDIR /opt

ENV GATEWAY_HOME /opt/knox-0.13.0

RUN apt-get update && \
    curl -f -L https://archive.apache.org/dist/knox/0.13.0/knox-0.13.0.tar.gz | tar zxf -
