FROM cloudsuite/spark-base:base

COPY start-worker-fg.sh /root/start-worker-fg.sh

ENV SPARK_WORKER_WEBUI_PORT=8080

EXPOSE ${SPARK_WORKER_WEBUI_PORT}

ENTRYPOINT ["/root/start-worker-fg.sh"]

