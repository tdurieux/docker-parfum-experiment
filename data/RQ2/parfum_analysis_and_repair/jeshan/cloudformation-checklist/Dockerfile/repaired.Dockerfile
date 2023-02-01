FROM node:8.16.0-slim

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/cache/apt && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

COPY package-lock.json .
RUN npm install && npm cache clean --force;

COPY package.json ./
RUN npm install --only=dev && npm cache clean --force;
RUN npm i -g gulp && npm cache clean --force;

COPY src src
COPY data data
COPY *.js .babelrc modernizr-config.json package.json .stylelintrc ./

ENTRYPOINT ["npm"]
RUN gulp build
