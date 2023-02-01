from        ubuntu
maintainer  Matthew Fisher <me@bacongobbler.com>

# Install prerequisites for elasticsearch to run
run apt-get update && apt-get install --no-install-recommends -q -y openjdk-6-jre-headless wget && rm -rf /var/lib/apt/lists/*;

# Install Elasticsearch to /opt
run         wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.1.tar.gz
run tar -xzf elasticsearch-0.90.1.tar.gz && rm elasticsearch-0.90.1.tar.gz
run         mv elasticsearch-0.90.1 /opt/elasticsearch

# clean up installation
run         rm elasticsearch-0.90.1.tar.gz

expose      9200

cmd         ["/opt/elasticsearch/bin/elasticsearch", "-f"]
