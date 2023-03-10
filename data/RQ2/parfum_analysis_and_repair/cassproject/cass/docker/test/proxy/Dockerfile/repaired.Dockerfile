FROM docker.elastic.co/elasticsearch/elasticsearch:7.16.2

RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash -
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt --no-install-recommends install -qqy nodejs git && rm -rf /var/lib/apt/lists/*;

ENV CASS_VERSION=1.5
COPY src CASS/src
COPY package.json CASS/package.json
COPY *.js CASS/

RUN cd CASS && \
npm install && npm cache clean --force;

ENV CASS_LOOPBACK=https://woohoo.i.dont.exist/api/
ENV CASS_LOOPBACK_PROXY=http://localhost/api/

RUN echo 'node.name: cass-a' >> config/elasticsearch.yml
RUN echo 'cluster.initial_master_nodes:' >> config/elasticsearch.yml
RUN echo '  - cass-a' >> config/elasticsearch.yml
EXPOSE 80
VOLUME ["/usr/share/elasticsearch/data","/usr/share/elasticsearch/CASS/etc","/usr/share/elasticsearch/CASS/logs"]
ENTRYPOINT /usr/local/bin/docker-entrypoint.sh & (cd CASS && npm run run:proxy && npm run logs)