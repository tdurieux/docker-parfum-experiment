FROM ubuntu:18.04

WORKDIR /root

# install dependencies
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    curl \
    openjdk-8-jdk-headless \
    openssh-server \
    tar && rm -rf /var/lib/apt/lists/*;

# set environment variables for hadoop
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre

# setup ssh
RUN ssh-keygen -t rsa -f /root/.ssh/id_rsa -P '' \
    && cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# mkdir for hadoop files
RUN mkdir -p /usr/local/hadoop

# specify the hadoop verison to use
ARG HADOOP_VER=2.9.1

# curl down hadoop and untar it into place
RUN curl -f -Lk -o hadoop.tar.gz https://www.gtlib.gatech.edu/pub/apache/hadoop/common/hadoop-${HADOOP_VER}/hadoop-${HADOOP_VER}.tar.gz \
    && tar -xvf hadoop.tar.gz -C /usr/local/hadoop --strip-components 1 \
    && rm hadoop.tar.gz

# set environment variables for hadoop path
ENV LD_LIBRARY_PATH=/usr/local/hadoop/lib/native:$LD_LIBRARY_PATH
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop


# mkdir for hadoop logs and hdfs data
RUN mkdir -p /usr/local/hadoop/logs \
    && mkdir -p /root/hadoop/data/namenode \
    && mkdir -p /root/hadoop/data/datanode

# copy config files
COPY config/* /usr/local/hadoop/etc/hadoop/
COPY config/ssh_config /root/.ssh/config

EXPOSE 5677 50070 9870 8088 22

CMD [ "sh", "-c", "service ssh start; sleep infinity"]
