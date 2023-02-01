FROM ludeeus/container:integration-debian

RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https gnupg2 procps less curl && rm -rf /var/lib/apt/lists/*;
RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
RUN echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list
RUN apt-get update && apt-get install -y --no-install-recommends elasticsearch && rm -rf /var/lib/apt/lists/*;
RUN chmod 7777 /var/log

RUN mv /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.old
COPY ".devcontainer/elasticsearch/config_7x" /etc/elasticsearch/