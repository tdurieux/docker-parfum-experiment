FROM golang:1.9.1

RUN echo "deb http://www.apache.org/dist/cassandra/debian 311x main" | tee -a /etc/apt/sources.list.d/cassandra.sources.list \
    && curl -f https://www.apache.org/dist/cassandra/KEYS | apt-key add - \
    && apt-get update && apt-get install --no-install-recommends cassandra -y && rm -rf /var/lib/apt/lists/*

RUN wget https://nodejs.org/dist/v12.3.1/node-v12.3.1-linux-x64.tar.gz \
    && tar -xf node-v12.3.1-linux-x64.tar.gz --directory /usr/local --strip-components 1 \
    && rm -rf node-v12.3.1-linux-x64.tar.gz \
    && npm install -g @vue/cli && npm cache clean --force;

CMD ["tail", "-f", "/dev/null"]