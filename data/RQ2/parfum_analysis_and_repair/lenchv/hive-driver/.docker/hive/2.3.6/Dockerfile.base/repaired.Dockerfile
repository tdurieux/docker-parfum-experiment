FROM openjdk:8u212-jre

WORKDIR /opt

ENV HADOOP_HOME=/opt/hadoop-2.9.2
ENV HIVE_HOME=/opt/apache-hive-2.3.6-bin
# Include additional jars
ENV HADOOP_CLASSPATH=/opt/hadoop-2.9.2/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.199.jar:/opt/hadoop-2.9.2/share/hadoop/tools/lib/hadoop-aws-2.9.2.jar

RUN apt-get update && \
    curl -f -L https://www-us.apache.org/dist/hive/hive-2.3.6/apache-hive-2.3.6-bin.tar.gz | tar zxf - && \
    curl -f -L https://www-us.apache.org/dist/hadoop/common/hadoop-2.9.2/hadoop-2.9.2.tar.gz | tar zxf -

RUN env DEBIAN_FRONTEND=noninteractive apt-get install -y krb5-user

COPY conf ${HIVE_HOME}/conf

WORKDIR $HIVE_HOME
EXPOSE 9083

