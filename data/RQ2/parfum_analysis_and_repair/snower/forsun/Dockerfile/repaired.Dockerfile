FROM ubuntu:20.04

MAINTAINER snower sujian199@gmail.com

VOLUME /forsun

EXPOSE 6458
EXPOSE 9002

WORKDIR /forsun

COPY docker/startup.sh /opt/

RUN apt update \
    && apt install --no-install-recommends -y curl openssl libssl-dev python3 python3-pip \
    && pip install --no-cache-dir --upgrade certifi \
    && pip install --no-cache-dir tornado==5.1 \
    && pip install --no-cache-dir thrift==0.11.0 \
    && pip install --no-cache-dir torthrift==0.2.4 \
    && pip install --no-cache-dir tornadis==0.8.1 \
    && pip install --no-cache-dir msgpack==0.5.1 \
    && pip install --no-cache-dir forsun==0.1.4 \
    && pip install --no-cache-dir pymysql==0.7.10 \
    && pip install --no-cache-dir tormysql==0.3.7 \
    && chmod +x /opt/startup.sh && rm -rf /var/lib/apt/lists/*;

CMD /opt/startup.sh