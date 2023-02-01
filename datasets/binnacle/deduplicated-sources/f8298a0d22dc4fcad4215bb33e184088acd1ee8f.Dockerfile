FROM daunnc/as-base:latest

MAINTAINER Grigory Pomadchin, daunnc@gmail.com

RUN apt-get install -y iputils-ping daemontools runit

ENV HADOOP_INSTALL /usr/local/hadoop
ENV ZOOKEEPER_HOME /usr/local/zookeeper
ENV ACCUMULO_HOME /usr/local/accumulo
ENV SPARK_HOME /usr/local/spark

RUN mkdir -p /home/hduser/hdfs/namenode  
RUN mkdir -p /home/hduser/hdfs/datanode 
 
RUN mkdir $HADOOP_INSTALL/logs

RUN mkdir -p /etc/service/serf
RUN mkdir -p /etc/service/sshd

ADD config/service /etc/service 

RUN chmod +x /etc/service/serf/run 
RUN chmod +x /etc/service/sshd/run 

ADD hadoop/hdfs-site.xml $HADOOP_INSTALL/etc/hadoop/hdfs-site.xml 
ADD hadoop/core-site.xml $HADOOP_INSTALL/etc/hadoop/core-site.xml 
ADD hadoop/mapred-site.xml $HADOOP_INSTALL/etc/hadoop/mapred-site.xml 
ADD hadoop/yarn-site.xml $HADOOP_INSTALL/etc/hadoop/yarn-site.xml 
ADD hadoop/slaves $HADOOP_INSTALL/etc/hadoop/slaves 

RUN chown -R hduser:hadoop /home/hduser/hdfs/namenode
RUN chown -R hduser:hadoop /home/hduser/hdfs/datanode
RUN chown -R hduser:hadoop $HADOOP_INSTALL/logs
RUN chmod 1777 /tmp

# Format namenode
RUN su hduser -c "/usr/local/hadoop/bin/hdfs namenode -format"

ADD config/bootstrap.sh $HADOOP_INSTALL/bin/bootstrap.sh
RUN chmod 755 $HADOOP_INSTALL/bin/bootstrap.sh
RUN chown hduser:hadoop /home/hduser/.ssh/config

ADD zookeeper/zoo.cfg $ZOOKEEPER_HOME/conf/zoo.cfg
ADD zookeeper/zookeeper-env.sh $ZOOKEEPER_HOME/zookeeper/conf/zookeeper-env.sh

ADD accumulo/* $ACCUMULO_HOME/conf/
ADD hadoop/masters $ACCUMULO_HOME/conf/masters
ADD hadoop/slaves $ACCUMULO_HOME/conf/slaves

RUN rm -f $SPARK_HOME/conf/*
ADD spark/* $SPARK_HOME/conf/
ADD hadoop/masters $SPARK_HOME/conf/masters
ADD hadoop/slaves $SPARK_HOME/conf/slaves

# SSH and SERF ports
EXPOSE 22 7373 7946 

# HDFS ports
EXPOSE 9000 50010 50020 50070 50075 50090 50475

# YARN ports
EXPOSE 8030 8031 8032 8033 8040 8042 8060 8088 50060

# Zookeeper ports
EXPOSE 2181 2888 3888

# Accumulo ports
EXPOSE 9999 9997 50091 50095 4560 12234

# Spark ports
EXPOSE 8080 8081 7077 4040 4041 18080

ENTRYPOINT ["/bin/bash", "/usr/local/hadoop/bin/bootstrap.sh"]
