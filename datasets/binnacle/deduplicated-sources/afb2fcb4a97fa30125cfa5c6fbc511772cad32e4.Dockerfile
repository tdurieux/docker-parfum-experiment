FROM cluster-hadoop

RUN wget http://mirrors.tuna.tsinghua.edu.cn/apache/kafka/0.10.2.1/kafka_2.11-0.10.2.1.tgz \
    && tar -zxvf /kafka_2.11-0.10.2.1.tgz -C /usr/local/ \
    && mv /usr/local/kafka_2.11-0.10.2.1 /usr/local/kafka \
    && rm /kafka_2.11-0.10.2.1.tgz \
    && mkdir -p /usr/local/kafka/kafka-logs

COPY ./conf/server.properties /usr/local/kafka/conf

ENV KAFKA_HOME=/usr/local/kafka
ENV PATH $KAFKA_HOME/bin:$PATH
