FROM java
RUN apt-get install --no-install-recommends -qq -y wget && rm -rf /var/lib/apt/lists/*;
RUN wget -nv https://download.elasticsearch.org/logstash/logstash/logstash-1.4.1.tar.gz ; tar xzf logstash-1.4.1.tar.gz && rm logstash-1.4.1.tar.gz
ADD logstash.conf logstash.conf
CMD logstash-1.4.1/bin/logstash -f logstash.conf
