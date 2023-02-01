FROM cloudsuite/java

RUN apt-get update \
 && apt-get install software-properties-common wget -y \
 && buildDeps='python' \
 && set -x \
 && apt-get install -y $buildDeps --no-install-recommends \
 && apt-get autoremove && apt-get clean && apt-get upgrade -y \
 && groupadd -r cassandra && useradd -r -g cassandra cassandra

RUN wget -q https://github.com/brianfrankcooper/YCSB/releases/download/0.3.0/ycsb-0.3.0.tar.gz -O /ycsb-0.3.0.tar.gz \
 && tar -xzf /ycsb-0.3.0.tar.gz && rm /ycsb-0.3.0.tar.gz && mv /ycsb-0.3.0 /ycsb \
 && chown cassandra:cassandra -R /ycsb/workloads

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

USER cassandra
