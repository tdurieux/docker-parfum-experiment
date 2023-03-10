FROM dlf-hive-base:latest

ENV METASTORE_HOME=/opt/apache-hive-3.1.2-bin

COPY conf/metastore-site.xml ${METASTORE_HOME}/conf/hive-site.xml
COPY conf/metastore-log4j2.properties ${METASTORE_HOME}/conf/metastore-log4j2.properties
COPY metastore-entrypoint.sh ${METASTORE_HOME}/entrypoint.sh

RUN groupadd -r hive --gid=1000 && \
    useradd -r -g hive --uid=1000 -d ${METASTORE_HOME} hive && \
    chown hive:hive -R ${METASTORE_HOME} && \
    mkdir /tmp/hive && \
    chmod -R a+w /tmp/hive/

USER hive
WORKDIR $METASTORE_HOME
EXPOSE 9083

ENTRYPOINT ["./entrypoint.sh"]
CMD ["bin/hive","--service","metastore"]