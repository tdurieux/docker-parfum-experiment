FROM node:alpine
LABEL author="iCrawl"

RUN yarn global add ts-node typescript && yarn cache clean;

COPY run.sh /var/run/
