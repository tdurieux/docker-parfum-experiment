FROM java
RUN apt-get install --no-install-recommends -qq -y wget && rm -rf /var/lib/apt/lists/*;
RUN wget -nv https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.2.1.tar.gz; tar xzf elasticsearch-1.2.1.tar.gz && rm elasticsearch-1.2.1.tar.gz
CMD elasticsearch-1.2.1/bin/elasticsearch
EXPOSE 9200