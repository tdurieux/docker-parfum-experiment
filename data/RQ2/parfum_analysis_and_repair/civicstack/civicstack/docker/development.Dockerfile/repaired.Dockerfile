FROM node:argon
MAINTAINER Matías Lescano <matias@democraciaenred.org>

RUN apt-get update && \
  apt-get install --no-install-recommends -y libkrb5-dev && \
  npm config set python python2.7 && rm -rf /var/lib/apt/lists/*;

COPY package.json /usr/src/

WORKDIR /usr/src

RUN npm install --quiet --unsafe-perm && npm cache clean --force;

EXPOSE 3000

CMD ["make"]
