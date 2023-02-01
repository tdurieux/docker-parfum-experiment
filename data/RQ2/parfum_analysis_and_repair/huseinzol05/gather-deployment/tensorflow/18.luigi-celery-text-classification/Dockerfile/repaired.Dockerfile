FROM ubuntu:16.04 AS base

RUN apt-get update && apt-get install --no-install-recommends -y \
    python3 \
    python3-pip \
    wget \
    rabbitmq-server \
    supervisor \
    openjdk-8-jdk-headless \
    wget \
    apt-transport-https && rm -rf /var/lib/apt/lists/*;

RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
RUN echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-6.x.list
RUN apt-get update && apt-get install --no-install-recommends elasticsearch kibana -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir Flask celery flower luigi
RUN pip3 install --no-cache-dir numpy pandas elasticsearch elasticsearch_dsl requests
RUN pip3 install --no-cache-dir tensorflow

WORKDIR /app

COPY . /app

RUN cp elasticsearch.yml /etc/elasticsearch/

RUN cp kibana.yml /etc/kibana/
