FROM ubuntu:xenial

ARG folio_registry=https://repository.folio.org/repository/npm-folioci/

RUN apt-get -q update && \
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y \
    -o Dpkg::Options::="--force-confnew"  --no-install-recommends \
    git ca-certificates wget unzip bzip2 xvfb && \
    apt-get install --no-install-recommends -y libgtk2.0-0 libxtst6 libxss1 libgconf-2-4 libnss3 libnspr4 libasound2 && \
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && \
    rm -f /var/cache/apt/*.bin

ENV NODEJS_VERSION 8

RUN wget --no-cookies https://deb.nodesource.com/setup_${NODEJS_VERSION}.x -O /tmp/node.sh  && \
    chmod +x /tmp/node.sh && \
    sh -c "/tmp/node.sh" && \
    rm -f /tmp/node.sh && \
    apt-get install --no-install-recommends -y nodejs && \
    npm install -g yarn && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/ui-testing

COPY test /usr/src/ui-testing/test
COPY LICENSE package.json docker-run.sh yarn.* *.js /usr/src/ui-testing/

RUN useradd -ms /bin/bash folio
RUN chown -R folio /usr/src/ui-testing
USER folio

RUN yarn config set @folio:registry $folio_registry && yarn cache clean;

RUN yarn install && yarn cache clean;

ENTRYPOINT ["./docker-run.sh"]

