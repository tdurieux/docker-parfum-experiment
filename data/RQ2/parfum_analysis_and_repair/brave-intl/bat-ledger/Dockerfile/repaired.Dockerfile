FROM node:11.15-stretch

RUN apt-get update && apt-get install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/src/app && mkdir /usr/src/app/bat-utils && rm -rf /usr/src/app
WORKDIR /usr/src/app

RUN npm install -g npm@6.7.0 && npm cache clean --force;

COPY package.json /usr/src/app/
COPY bat-utils/package.json /usr/src/app/bat-utils/
RUN npm install && npm cache clean --force;
COPY . /usr/src/app

CMD npm run eyeshade-consumer
