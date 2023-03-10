FROM node:0.10.40
MAINTAINER Hussein Galal

ENV GITHUB_REPO=https://github.com/galal-hussein/gamehub.io.git

RUN mkdir -p /var/www/app
WORKDIR /var/www/app

RUN apt-get update \
&& apt-get install -y --no-install-recommends git \
&& git clone $GITHUB_REPO . \
&& npm install && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

ADD ./config/default.json config/default.json
#ADD ./initData.js initData.js

EXPOSE 3000

CMD node initData.js; node .
