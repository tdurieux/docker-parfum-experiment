# shared

FROM node:4

RUN apt-get update && apt-get install --no-install-recommends -y net-tools && rm -rf /var/lib/apt/lists/*;

ADD package.json /

RUN npm install && npm cache clean --force;
