FROM couchbase/server:enterprise-4.5.1

RUN apt-get update && apt-get install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;

COPY configure-server.sh /opt/couchbase
CMD ["/opt/couchbase/configure-server.sh"]