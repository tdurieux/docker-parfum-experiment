FROM docker.elastic.co/logstash/logstash:7.1.1
COPY zentral_beats.cfg /usr/share/logstash/pipeline/logstash.conf
