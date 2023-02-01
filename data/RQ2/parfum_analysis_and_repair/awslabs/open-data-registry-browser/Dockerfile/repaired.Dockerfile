FROM node:14.16-stretch-slim

RUN apt-get update \
    && apt-get install --no-install-recommends -y curl git openssl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY package.json /app/package.json
WORKDIR /app

RUN npm install && npm cache clean --force;

COPY . /app

RUN npm test
RUN npm run copy-data

CMD BASE_URL=https://registry.opendata.aws npm run serve

