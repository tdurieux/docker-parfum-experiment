# this dockerfile is needed if building the puppeteer layer from a non-unix machine
FROM node:14.16-slim

WORKDIR /home/build

RUN apt-get update -y && apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;

COPY package.json /home/build/nodejs/package.json
COPY package-lock.json /home/build/nodejs/package-lock.json
RUN cd /home/build/nodejs/ && npm ci
RUN zip -r puppeteer_lambda_layer.zip nodejs

CMD echo "puppeteer zip has been created"
