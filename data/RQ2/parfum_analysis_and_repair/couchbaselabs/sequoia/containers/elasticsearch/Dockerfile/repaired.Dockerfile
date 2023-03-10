FROM ubuntu_python

#
# Elasticsearch Dockerfile
#
# https://github.com/dockerfile/elasticsearch
#

RUN apt-get wget
# Pull base image.
RUN yes | apt-get install -y --no-install-recommends default-jdk && rm -rf /var/lib/apt/lists/*;

ENV ES_PKG_NAME elasticsearch-1.7.0

# Install Elasticsearch.
RUN \
  cd / && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz && \
  tar xvzf $ES_PKG_NAME.tar.gz && \
  rm -f $ES_PKG_NAME.tar.gz && \
  mv /$ES_PKG_NAME /elasticsearch

# Define mountable directories.
VOLUME ["/data"]

# Mount elasticsearch.yml config
ADD config/elasticsearch.yml /elasticsearch/config/elasticsearch.yml

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["/elasticsearch/bin/elasticsearch"]

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300