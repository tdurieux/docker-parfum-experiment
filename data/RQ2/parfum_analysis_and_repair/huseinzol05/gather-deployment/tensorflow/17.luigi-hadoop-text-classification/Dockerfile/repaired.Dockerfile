FROM ubuntu:16.04 AS base

ENV HADOOP_HOME /opt/hadoop
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN apt-get update && apt-get install --no-install-recommends -y \
    python3 \
    python3-pip \
    openjdk-8-jdk \
    wget \
    ssh && rm -rf /var/lib/apt/lists/*;

RUN wget https://www-eu.apache.org/dist/hadoop/common/hadoop-3.1.1/hadoop-3.1.1.tar.gz && \
    tar -xzf hadoop-3.1.1.tar.gz && \
    mv hadoop-3.1.1 $HADOOP_HOME && \
    for user in hadoop hdfs yarn mapred; do \
        useradd -U -M -d /opt/hadoop/ --shell /bin/bash ${user}; \
    done && \
    for user in root hdfs yarn mapred; do \
        usermod -G hadoop ${user}; \
    done && \
    echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HDFS_DATANODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HDFS_NAMENODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HDFS_SECONDARYNAMENODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export YARN_RESOURCEMANAGER_USER=root" >> $HADOOP_HOME/etc/hadoop/yarn-env.sh && \
    echo "export YARN_NODEMANAGER_USER=root" >> $HADOOP_HOME/etc/hadoop/yarn-env.sh && \
    echo "PATH=$PATH:$HADOOP_HOME/bin" >> ~/.bashrc && rm hadoop-3.1.1.tar.gz

RUN apt-get install --no-install-recommends openssh-client -y && \
    ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys && rm -rf /var/lib/apt/lists/*;

ADD *xml $HADOOP_HOME/etc/hadoop/

ADD ssh_config /root/.ssh/config

RUN pip3 install --no-cache-dir tensorflow numpy docutils
RUN pip3 install --no-cache-dir luigi python-daemon jupyter
RUN echo

RUN jupyter notebook --generate-config

RUN echo "" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.token = ''" >> /root/.jupyter/jupyter_notebook_config.py

WORKDIR /app

COPY . /app

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
