ARG ES_VERSION=7.13.2

FROM docker.elastic.co/elasticsearch/elasticsearch:${ES_VERSION}

ARG ES_VERSION=7.13.2

RUN echo elasticsearch-plugin install --batch \
  https://github.com/anti-social/jmorphy2/releases/download/v0.2.2-es${ES_VERSION}/analysis-jmorphy2-0.2.2-es${ES_VERSION}.zip