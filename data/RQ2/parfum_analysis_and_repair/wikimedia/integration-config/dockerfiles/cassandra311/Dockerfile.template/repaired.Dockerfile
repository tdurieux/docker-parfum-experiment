FROM docker-registry.wikimedia.org/stretch:latest

COPY cassandra311.list /etc/apt/sources.list.d/cassandra311.list

RUN {{ "cassandra cassandra-tools-wmf libjemalloc1 procps iproute2" | apt_install }}

ENV CASSANDRA_HOME /opt/cassandra
ENV CASSANDRA_CONF /etc/cassandra
ENV PATH $CASSANDRA_HOME/bin:$PATH

RUN groupadd -o -g "999" -r "runuser" && useradd -l -o -m -d "/home/runuser" -r -g "runuser" -u "999" "runuser"

RUN mkdir -p "$CASSANDRA_CONF" /var/lib/cassandra /var/log/cassandra \
    && chown -R 999:999 "$CASSANDRA_CONF" /var/lib/cassandra /var/log/cassandra \
    && chmod 700 "$CASSANDRA_CONF" /var/lib/cassandra /var/log/cassandra

USER runuser

COPY entrypoint.sh /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]
CMD ["cassandra", "-f"]
EXPOSE 7000 7001 7199 9042 9160