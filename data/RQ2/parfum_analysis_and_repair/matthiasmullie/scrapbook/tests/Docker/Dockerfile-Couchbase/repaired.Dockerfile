FROM couchbase:5.1.1
COPY tests/Docker/build-couchbase.sh /opt/couchbase/build-couchbase.sh
CMD ["/opt/couchbase/build-couchbase.sh"]