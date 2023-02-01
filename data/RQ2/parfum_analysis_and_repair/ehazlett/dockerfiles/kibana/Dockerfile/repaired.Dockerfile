FROM nginx:1
RUN apt-get update && apt-get install --no-install-recommends -y wget ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN wget https://download.elasticsearch.org/kibana/kibana/kibana-3.1.2.tar.gz -O /tmp/kibana.tar.gz && \
    cd /tmp && tar zxf kibana.tar.gz && mv kibana-*/* /usr/share/nginx/html/ && rm kibana.tar.gz
EXPOSE 80
