FROM cassandra:2.2

RUN mkdir -vp /data/data /data/commitlog /data/saved_caches\
  && chown -vR cassandra:cassandra /data \
  && chmod -vv 777 /data
COPY ./cassandra.yaml /etc/cassandra/cassandra.yaml
RUN echo "JVM_OPTS=\"\$JVM_OPTS -Dcassandra.skip_wait_for_gossip_to_settle=0\"" >> $CASSANDRA_CONF/cassandra-env.sh
CMD ["-d", "cassandra.config=/etc/cassandra/cassandra.yaml"]