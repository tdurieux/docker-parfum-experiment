FROM openkbs/jdk11-mvn-py3

ARG ssh_prv_key
ARG ssh_pub_key
ENV kafkaversion=2.5.0
ENV ESERV_HOME=/tmp

RUN mkdir -p /kafka-connect/kafka
RUN mkdir /kafka-connect/logs

RUN apt-get update && apt-get install --no-install-recommends -y \
git openssh-client openssl musl-dev curl && rm -rf /var/lib/apt/lists/*;

RUN wget -q https://bootstrap.pypa.io/get-pip.py -P / && python get-pip.py && pip install --no-cache-dir requests && pip install --no-cache-dir psutil

RUN wget -q https://apache.mirrors.hoobly.com/kafka/${kafkaversion}/kafka_2.12-${kafkaversion}.tgz -P / && \
 tar -xf kafka_2.12-2.5.0.tgz -C /kafka-connect/kafka --strip-components 1 && rm -f kafka_2.12-${kafkaversion}.tgz

RUN ssh-keygen -f ${ESERV_HOME}/id_rsa -t rsa -N '' && \
    cp ${ESERV_HOME}/id_rsa.pub ${ESERV_HOME}/authorized_keys && \
    chmod 640 ${ESERV_HOME}/authorized_keys

WORKDIR /kafka-connect

ADD run_kafka_connect.sh /kafka-connect/run_kafka_connect.sh
ADD config.yaml /kafka-connect/config.yaml

EXPOSE 9092 8083
CMD ["/bin/bash", "-c", "/kafka-connect/run_kafka_connect.sh"]
