FROM cloudsuite/spark-base:base

COPY start-master-fg.sh /root/start-master-fg.sh

ENV SPARK_MASTER_PORT=7077 \
    SPARK_MASTER_WEBUI_PORT=8080

EXPOSE ${SPARK_MASTER_PORT} ${SPARK_MASTER_WEBUI_PORT}

ENTRYPOINT ["/root/start-master-fg.sh"]

