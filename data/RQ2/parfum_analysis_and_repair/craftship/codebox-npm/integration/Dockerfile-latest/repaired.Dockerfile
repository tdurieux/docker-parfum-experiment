FROM node:7.5.0

ARG sls_version

ADD . /codebox

WORKDIR /codebox

RUN npm install --silent && npm cache clean --force;

RUN npm install serverless@$sls_version -g --silent && npm cache clean --force;

CMD ./integration/bin/test
