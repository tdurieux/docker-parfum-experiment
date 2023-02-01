FROM dlf-hive-base:latest

ENV HIVE_HOME=/opt/apache-hive-3.1.2-bin

COPY conf/hive-site.xml ${HIVE_HOME}/conf/
COPY hiveserver-entrypoint.sh ${HIVE_HOME}/entrypoint.sh

RUN groupadd -r hive --gid=1000 && \
    useradd -r -g hive --uid=1000 -d ${HIVE_HOME} hive && \
    chown hive:hive -R ${HIVE_HOME} && \
    mkdir /tmp/hive && \
    chmod -R a+w /tmp/hive/

USER hive
WORKDIR $HIVE_HOME
EXPOSE 10001 10002

ENTRYPOINT ["./entrypoint.sh"]
CMD ["bin/hive","--service","hiveserver2"]