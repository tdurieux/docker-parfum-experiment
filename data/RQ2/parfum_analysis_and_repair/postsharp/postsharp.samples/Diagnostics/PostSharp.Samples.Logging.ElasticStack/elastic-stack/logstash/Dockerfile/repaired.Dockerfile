# https://github.com/elastic/logstash-docker
FROM docker.elastic.co/logstash/logstash-oss:6.2.3
RUN logstash-plugin install logstash-input-http

# Add your logstash plugins setup here
# Example: RUN logstash-plugin install logstash-filter-json