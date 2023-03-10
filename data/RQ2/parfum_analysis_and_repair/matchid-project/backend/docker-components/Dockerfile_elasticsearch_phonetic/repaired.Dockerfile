FROM docker.elastic.co/elasticsearch/elasticsearch-oss:6.2.2
ARG proxy
ENV https_proxy $proxy
RUN wget https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-phonetic/analysis-phonetic-6.2.2.zip -O /tmp/analysis-phonetic-6.2.2.zip `echo $proxy | sed 's/\(\S\S*\)/-e use_proxy=yes/'` > /tmp/analysis-phonetic-6.2.2.zip
RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install file:///tmp/analysis-phonetic-6.2.2.zip