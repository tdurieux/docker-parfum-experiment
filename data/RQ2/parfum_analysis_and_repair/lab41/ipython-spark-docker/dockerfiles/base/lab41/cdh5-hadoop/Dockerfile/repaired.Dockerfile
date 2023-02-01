# CDH5
##NOTE: identical copy from Rich Haase <rdhaase@gmail.com> richhaase/cdh5-hadoop image, which builds on Ubuntu:12.04
##      Adding this temporarily until an Ubuntu:14.04 version exists upstream
FROM lab41/oracle-jdk7
MAINTAINER Kyle F "kylef@lab41.org"
ENV REFRESHED_AT 2015-07-29

# CDH5 Repositories
RUN cd /tmp && \
    wget https://archive.cloudera.com/cdh5/one-click-install/precise/amd64/cdh5-repository_1.0_all.deb && \
    dpkg -i cdh5-repository_1.0_all.deb
RUN wget -q https://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/archive.key -O - | apt-key add -
RUN wget -q https://archive.cloudera.com/gplextras5/ubuntu/precise/amd64/gplextras/cloudera.list -O /etc/apt/sources.list.d/gplextras.list
RUN apt-get update

# Hadoop core packages
RUN apt-get install --no-install-recommends -yqq hadoop-yarn-resourcemanager hadoop-0.20-mapreduce-jobtracker \
    hadoop-hdfs-namenode hadoop-hdfs-secondarynamenode hadoop-yarn-nodemanager \
    hadoop-0.20-mapreduce-tasktracker hadoop-hdfs-datanode hadoop-mapreduce \
    hadoop-mapreduce-historyserver hadoop-yarn-proxyserver hadoop-client && rm -rf /var/lib/apt/lists/*;

# Hadoop ecosystem packages
#
# HBase
RUN apt-get install --no-install-recommends -yqq hbase && rm -rf /var/lib/apt/lists/*;

# Hive
RUN apt-get install --no-install-recommends -yqq hive && rm -rf /var/lib/apt/lists/*;

# Oozie
RUN apt-get install --no-install-recommends -yqq oozie oozie-client && rm -rf /var/lib/apt/lists/*;

# Pig
RUN apt-get install --no-install-recommends -yqq pig pig-udf-datafu && rm -rf /var/lib/apt/lists/*;

# Spark
RUN apt-get install --no-install-recommends -yqq spark-core spark-master spark-worker spark-history-server spark-python && rm -rf /var/lib/apt/lists/*;

# Hue
RUN apt-get install --no-install-recommends -yqq hue hue-plugins && rm -rf /var/lib/apt/lists/*;
