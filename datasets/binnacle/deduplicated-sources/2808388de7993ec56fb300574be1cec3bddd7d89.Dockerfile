FROM cluster-base

# hadoop 环境安装：
RUN wget http://archive.apache.org/dist/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz \
    && tar -zxvf /hadoop-2.6.0.tar.gz -C /usr/local/ \
    && mv /usr/local/hadoop-2.6.0 /usr/local/hadoop \
    && mkdir /usr/local/hadoop/tmp/ \ 
    && mkdir /usr/local/hadoop/data/ \   
    && mkdir /usr/local/hadoop/name/ \ 
    && rm /hadoop-2.6.0.tar.gz

# java8 环境。
ENV JAVA_HOME=/usr/local/jdk1.8
ENV PATH $JAVA_HOME/bin:$PATH

# hadoop 环境。
ENV HADOOP_HOME=/usr/local/hadoop
ENV PATH $HADOOP_HOME/bin:$PATH
ENV HADOOP_PREFIX=$HADOOP_HOME

RUN cd $HADOOP_HOME	\
	&& echo "export JAVA_HOME=$JAVA_HOME" >> etc/hadoop/hadoop-env.sh \
	&& echo "export HADOOP_PREFIX=$HADOOP_PREFIX" >> etc/hadoop/hadoop-env.sh \
	&& echo "export JAVA_HOME=$JAVA_HOME" >> etc/hadoop/yarn-env.sh

COPY ./conf/core-site.xml   $HADOOP_HOME/etc/hadoop
COPY ./conf/hdfs-site.xml   $HADOOP_HOME/etc/hadoop
COPY ./conf/mapred-site.xml $HADOOP_HOME/etc/hadoop
COPY ./conf/yarn-site.xml   $HADOOP_HOME/etc/hadoop
COPY ./conf/masters         $HADOOP_HOME/etc/hadoop
COPY ./conf/slaves          $HADOOP_HOME/etc/hadoop

WORKDIR /hadoop

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
