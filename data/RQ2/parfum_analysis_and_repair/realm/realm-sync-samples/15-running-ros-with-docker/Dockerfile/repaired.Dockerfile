FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install --no-install-recommends --yes curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends --yes build-essential libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends --yes python && rm -rf /var/lib/apt/lists/*;

RUN curl -f --silent --location -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install --no-install-recommends --yes nodejs && rm -rf /var/lib/apt/lists/*;

COPY package.json package.json
COPY index.js index.js

RUN npm install && npm cache clean --force;

EXPOSE 9080

ENTRYPOINT [ "" ]
CMD ["node", "index.js"]