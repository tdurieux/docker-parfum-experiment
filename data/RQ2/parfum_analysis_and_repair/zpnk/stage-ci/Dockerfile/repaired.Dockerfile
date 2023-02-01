FROM node:7-slim

RUN apt-get -y update && apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

WORKDIR /stage-ci

COPY package.json .
RUN npm install --production && npm cache clean --force;

ADD . .

EXPOSE 3000

CMD npm start
