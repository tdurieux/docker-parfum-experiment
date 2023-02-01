FROM node:lts-alpine3.11
RUN apk add --no-cache python make g++
COPY . /var/app
WORKDIR /var/app
RUN yarn
RUN cat yarn.lock

CMD /bin/sh