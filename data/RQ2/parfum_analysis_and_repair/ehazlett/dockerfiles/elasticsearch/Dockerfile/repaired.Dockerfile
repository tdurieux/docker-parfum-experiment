FROM debian:jessie
RUN apt-get update && \
    apt-get install --no-install-recommends -y openjdk-7-jre wget && rm -rf /var/lib/apt/lists/*;
ENV JAVA_HOME /usr/lib/jvm/java-6-openjdk-amd64
RUN ( cd /tmp && \
    wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.0.tar.gz -O pkg.tar.gz && \
    tar zxf pkg.tar.gz && mv elasticsearch-* /opt/elasticsearch &&\
    rm -rf /tmp/*) && rm pkg.tar.gz
COPY elasticsearch.yml /opt/elasticsearch/config/elasticsearch.yml
EXPOSE 9200
EXPOSE 9300
VOLUME /opt/elasticsearch/data
ENTRYPOINT ["/opt/elasticsearch/bin/elasticsearch"]
CMD []
