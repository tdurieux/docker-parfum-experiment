FROM docker.elastic.co/elasticsearch/elasticsearch:6.6.1
LABEL maintainer Yuki Takei <yuki@weseek.co.jp>

RUN bin/elasticsearch-plugin install analysis-kuromoji
RUN bin/elasticsearch-plugin install analysis-icu
