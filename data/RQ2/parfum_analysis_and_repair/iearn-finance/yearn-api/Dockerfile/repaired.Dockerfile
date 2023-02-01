FROM node:12-buster

# default to dev but this can be overwritten by docker-compose
ENV SERVERLESS_STAGE dev

RUN npm install -g serverless && \
    npm install -g serverless-offline && npm cache clean --force;

RUN apt-get update && apt-get -y --no-install-recommends install default-jre && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 3000

RUN sls dynamodb install

RUN chmod 777 ./startserverless.sh

ENTRYPOINT ./startserverless.sh
