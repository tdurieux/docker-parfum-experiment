FROM ubuntu:16.04

COPY nifi nifi

COPY hadoop hadoop

COPY start.sh start.sh

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends wget \
    default-jdk \
    vim \
    krb5-user \
    sasl2-bin libsasl2-2 libsasl2-modules libsasl2-dev libldap2-dev \
    python3 python3-dev python3-pip python3-requests-kerberos build-essential && \
    pip3 install --upgrade pip && \
    pip3 install setuptools && \
    pip3 install thrift_sasl==0.2.1 sasl impyla hdfs polling && \
    rm -rf /hadoop/etc/hadoop && \
    ln -sf /etc/hadoop/conf /hadoop/etc/hadoop && \
    chmod +x /start.sh

EXPOSE 9090

ENTRYPOINT ["/start.sh"]