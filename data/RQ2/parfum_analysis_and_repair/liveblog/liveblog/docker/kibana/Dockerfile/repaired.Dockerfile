# import base image
FROM ubuntu:trusty

# Dependencies
RUN apt-get update -qq && sudo apt-get install --no-install-recommends -y -qq nginx-full wget && rm -rf /var/lib/apt/lists/*;

# Kibana
RUN mkdir -p /opt/kibana
RUN wget https://download.elasticsearch.org/kibana/kibana/kibana-4.0.2-linux-x64.tar.gz -O /tmp/kibana.tar.gz && \
 tar zxf /tmp/kibana.tar.gz && mv kibana-4.0.2-linux-x64/* /opt/kibana/ && rm /tmp/kibana.tar.gz

# Configs
ADD kibana.yml /opt/kibana/config/kibana.yml

EXPOSE 5601

CMD /opt/kibana/bin/kibana
