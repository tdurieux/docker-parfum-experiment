FROM ubuntu:latest
RUN apt-get update && apt-get install --no-install-recommends -y \
    wget \
    gnupg \
    curl \
    p7zip-full \
    default-jre && rm -rf /var/lib/apt/lists/*;

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.2.3.deb
RUN dpkg -i elasticsearch-6.2.3.deb
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get update && apt-get install --no-install-recommends -y \
    default-jre \
    nodejs && rm -rf /var/lib/apt/lists/*;

RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-icu
RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-smartcn

RUN npm install elasticdump -g && npm cache clean --force;

COPY elastic-dump.7z /tmp/elastic-dump.7z
COPY build.sh /tmp/build.sh
COPY elasticsearch.yml /etc/elasticsearch/

RUN chmod +r /etc/elasticsearch/elasticsearch.yml
RUN chmod +x /tmp/build.sh

EXPOSE 9200 9300

CMD service elasticsearch start && tail -f var/log/elasticsearch/docker-cluster.log
