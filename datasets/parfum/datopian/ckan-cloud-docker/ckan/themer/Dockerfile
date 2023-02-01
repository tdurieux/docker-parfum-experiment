FROM viderum/ckan-cloud-docker:ckan-latest

USER root

# Install required system packages
RUN apt-get -q -y --force-yes update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q -y --force-yes upgrade \
    && apt-get -q -y --force-yes install \
        curl \
    && apt-get -q clean \
    && rm -rf /var/lib/apt/lists/*

# Install less compiler
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash - && \
    apt-get install -y --force-yes nodejs && \
    npm install -g less && \
    mkdir -p /usr/lib/node_modules/.bin && \
    ln -s /usr/bin/lessc /usr/lib/node_modules/.bin/lessc

COPY themer.sh /themer.sh

USER ckan

ENTRYPOINT ["/themer.sh"]
