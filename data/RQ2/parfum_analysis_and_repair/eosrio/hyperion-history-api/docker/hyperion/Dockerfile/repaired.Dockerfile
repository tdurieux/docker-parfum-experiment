FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade -y && apt-get autoremove && apt-get install --no-install-recommends -y build-essential git curl netcat && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && npm install pm2 -g && git clone https://github.com/eosrio/hyperion-history-api.git && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

RUN useradd -m -s /bin/bash hyperion && chown -R hyperion:hyperion /hyperion-history-api
USER hyperion
WORKDIR /hyperion-history-api

RUN npm install && npm cache clean --force;

EXPOSE 7001

