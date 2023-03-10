FROM bde2020/spark-base:2.1.0-hadoop2.7
LABEL maintainer="edxops"

RUN echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list

ADD docker/build/analytics_pipeline_spark_master/master.sh /
ENV SPARK_MASTER_PORT=7077 \
    SPARK_MASTER_WEBUI_PORT=8080 \
    SPARK_MASTER_LOG=/spark/logs \
    HADOOP_USER_NAME=hadoop \
    SPARK_HOME=/spark \
    PATH=$PATH:/spark/bin \
    CORE_CONF_fs_defaultFS=hdfs://namenode:8020 \
    CORE_CONF_hadoop_http_staticuser_user=root \
    CORE_CONF_hadoop_proxyuser_hue_hosts=* \
    CORE_CONF_hadoop_proxyuser_hue_groups=* \
    HDFS_CONF_dfs_webhdfs_enabled=true \
    HDFS_CONF_dfs_permissions_enabled=false \
    YARN_CONF_yarn_log___aggregation___enable=true \
    YARN_CONF_yarn_resourcemanager_recovery_enabled=true \
    YARN_CONF_yarn_resourcemanager_store_class=org.apache.hadoop.yarn.server.resourcemanager.recovery.FileSystemRMStateStore \
    YARN_CONF_yarn_resourcemanager_fs_state___store_uri=/rmstate \
    YARN_CONF_yarn_nodemanager_remote___app___log___dir=/app-logs \
    YARN_CONF_yarn_log_server_url=http://historyserver:8188/applicationhistory/logs/ \
    YARN_CONF_yarn_timeline___service_enabled=true \
    YARN_CONF_yarn_timeline___service_generic___application___history_enabled=true \
    YARN_CONF_yarn_resourcemanager_system___metrics___publisher_enabled=true \
    YARN_CONF_yarn_resourcemanager_hostname=resourcemanager \
    YARN_CONF_yarn_timeline___service_hostname=historyserver \
    YARN_CONF_yarn_resourcemanager_address=resourcemanager:8032 \
    YARN_CONF_yarn_resourcemanager_scheduler_address=resourcemanager:8030 \
    YARN_CONF_yarn_resourcemanager_resource__tracker_address=resourcemanager:8031

RUN apt-get -o Acquire::Check-Valid-Until=false update && apt-get -y --no-install-recommends install --reinstall python-pkg-resources \
    && echo 'spark.master  spark://sparkmaster:7077\nspark.eventLog.enabled  true\nspark.eventLog.dir  hdfs://namenode:8020/tmp/spark-events\nspark.history.fs.logDirectory  hdfs://namenode:8020/tmp/spark-events' > /spark/conf/spark-defaults.conf && rm -rf /var/lib/apt/lists/*;

CMD ["/bin/bash", "/master.sh"]
# 18080: spark history server port
# 4040: spark UI port
# 6066: spark api port
EXPOSE 8080 7077 6066 18080 4040
