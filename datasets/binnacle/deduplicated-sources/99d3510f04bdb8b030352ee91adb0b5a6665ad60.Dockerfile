FROM nordstrom/java-7:u75
MAINTAINER Innovation Platform Team "invcldtm@nordstrom.com"

ENV LOGSTASH_RELEASE 1.5.0.beta1
ADD dist/logstash-$LOGSTASH_RELEASE.tar.gz /opt/
RUN ln -s /opt/logstash-$LOGSTASH_RELEASE /opt/logstash
RUN /opt/logstash/bin/plugin install logstash-input-kafka \
 && /opt/logstash/bin/plugin install logstash-output-elasticsearch

ADD conf/logstash.conf /opt/logstash/conf/

CMD ["/opt/logstash/bin/logstash", "-f", "/opt/logstash/conf/logstash.conf"]
