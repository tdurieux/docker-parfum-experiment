FROM java:openjdk-7-jdk

ENV project_version 1.0.2
ENV project_name replay

COPY target/${project_name}-${project_version}-bin.tar.gz /opt/app/${project_name}-${project_version}-bin.tar.gz
WORKDIR /opt/app
RUN tar -zxvf ${project_name}-${project_version}-bin.tar.gz && rm ${project_name}-${project_version}-bin.tar.gz
RUN ln -s /opt/app/${project_name}-${project_version} jetstreamapp
WORKDIR /opt/app/jetstreamapp

# App config
ENV JETSTREAM_APP_JAR_NAME ${project_name}.jar
ENV JETSTREAM_APP_NAME ${project_name}
ENV JETSTREAM_CONFIG_VERSION 1.0


# Dependency
ENV JETSTREAM_ZKSERVER_HOST zkserver
ENV JETSTREAM_ZKSERVER_PORT 2181
ENV JETSTREAM_MONGOURL mongo://mongoserver:27017/config
ENV PULSAR_KAFKA_ZK kafkaserver:2181
ENV PULSAR_KAFKA_BROKERS kafkaserver:9092

# Three Context ports, actually not used
ENV JETSTREAM_CONTEXT_BASEPORT 15590
ENV JETSTREAM_APP_PORT 9999

EXPOSE 9999 15590 15591 15592
ENTRYPOINT ./start.sh
