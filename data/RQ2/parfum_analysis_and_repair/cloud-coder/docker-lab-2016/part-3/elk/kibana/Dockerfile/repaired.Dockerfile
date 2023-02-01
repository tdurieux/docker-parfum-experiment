FROM kibana:4.6.0
RUN apt-get -y update && apt-get install --no-install-recommends -y curl nano && rm -rf /var/lib/apt/lists/*;
ENV ELASTICSEARCH_URL=http://elasticsearch:9200
