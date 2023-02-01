FROM node:10

RUN apt-get update && apt-get install --no-install-recommends -y docker curl build-essential && rm -rf /var/lib/apt/lists/*;

RUN curl -f -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && \
chmod +x /tmp/docker-machine && \
cp /tmp/docker-machine /usr/local/bin/docker-machine

WORKDIR /usr/src/app

COPY . /usr/src/app/

RUN yarn install && yarn cache clean;

EXPOSE 443 80 3000

CMD ["yarn", "start"]
