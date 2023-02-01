FROM node:10-alpine
MAINTAINER Learn Forward Ltd hypersay.com
RUN apk add --no-cache --update git make gcc g++ python rsync
RUN npm install -g lfa && npm cache clean --force;
ENTRYPOINT ["lfa"]
