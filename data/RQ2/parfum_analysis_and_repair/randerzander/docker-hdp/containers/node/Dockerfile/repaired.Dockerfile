FROM centos:6
ARG AMBARI_REPO_URL
ARG HDP_REPO_URL
RUN yum install -y sudo wget openssl-devel postgresql-jdbc mysql-connector-java unzip && rm -rf /var/cache/yum
RUN wget -nv ${AMBARI_REPO_URL} -O /etc/yum.repos.d/ambari.repo
RUN wget -nv ${HDP_REPO_URL} -O /etc/yum.repos.d/hdp.repo
# Uncomment if you want to run kerberos in container
# RUN yum install -y krb5-server krb5-libs krb5-workstation
RUN yum install -y ambari-agent && rm -rf /var/cache/yum
RUN yum install -y ambari-metrics-* && rm -rf /var/cache/yum
RUN yum install -y ambari-logsearch-* && rm -rf /var/cache/yum
RUN yum install -y hadoop* && rm -rf /var/cache/yum
RUN yum install -y zookeeper* && rm -rf /var/cache/yum
RUN yum install -y hive* && rm -rf /var/cache/yum
RUN yum install -y phoenix_* && rm -rf /var/cache/yum
RUN yum install -y ranger* && rm -rf /var/cache/yum
RUN yum install -y storm_* && rm -rf /var/cache/yum
RUN yum install -y kafka_* && rm -rf /var/cache/yum
RUN yum install -y pig_* && rm -rf /var/cache/yum
RUN yum install -y datafu_* && rm -rf /var/cache/yum
RUN yum install -y spark* livy* && rm -rf /var/cache/yum
RUN yum install -y zeppelin* && rm -rf /var/cache/yum
RUN yum install -y falcon_* && rm -rf /var/cache/yum
RUN yum install -y oozie_* && rm -rf /var/cache/yum
#RUN yum install -y lucidworks-hdpsearch
RUN yum install -y smartsense* && rm -rf /var/cache/yum
RUN yum install -y druid* && rm -rf /var/cache/yum
RUN yum install -y superset* && rm -rf /var/cache/yum
RUN yum install -y lzo snappy-devel rpcbind && rm -rf /var/cache/yum
RUN rm /etc/yum.repos.d/hdp*.repo
ADD scripts/start.sh /start.sh
CMD /start.sh
