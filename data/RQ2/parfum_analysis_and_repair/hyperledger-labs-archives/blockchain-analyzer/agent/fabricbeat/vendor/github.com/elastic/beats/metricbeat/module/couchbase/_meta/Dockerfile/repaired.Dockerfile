FROM couchbase:4.5.1
HEALTHCHECK CMD [ [ "$( curl -f -s -o /dev/null -w ''%{http_code}'' https://localhost:8091/pools/default/buckets/beer-sample)" -eq "200" ]]
COPY configure-node.sh /opt/couchbase

CMD ["/opt/couchbase/configure-node.sh"]
