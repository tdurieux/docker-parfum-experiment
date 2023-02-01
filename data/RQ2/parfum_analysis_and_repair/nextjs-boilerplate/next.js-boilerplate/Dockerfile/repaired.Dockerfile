FROM ubuntu:16.04

WORKDIR /app

RUN apt-get update -y && apt-get install --no-install-recommends -yq curl sudo \
&& curl -f -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - \
&& apt-get install --no-install-recommends -yq nodejs python2.7 make build-essential && rm -rf /var/lib/apt/lists/*;

ENV NODE_ENV=production PORT=80

ADD . /app

RUN npm install && npm run build && npm cache clean --force;

EXPOSE 80

CMD ["node", "server.js"]
