FROM ubuntu:16.04 AS base

RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    git \
    python3 \
    python3-pip \
    python3-wheel \
    openjdk-8-jdk-headless \
    wget \
    apt-transport-https \
    supervisor && rm -rf /var/lib/apt/lists/*;

RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -

RUN echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-6.x.list

RUN apt-get update && apt-get install -y --no-install-recommends elasticsearch && rm -rf /var/lib/apt/lists/*;

RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -

RUN echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-6.x.list

RUN apt-get update && apt-get install -y --no-install-recommends kibana && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir Flask

WORKDIR /app

COPY . /app

RUN cp elasticsearch.yml /etc/elasticsearch/

RUN cp kibana.yml /etc/kibana/
