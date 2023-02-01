FROM ubuntu:20.04

WORKDIR /root

RUN apt-get update && apt-get install --no-install-recommends -y curl gnupg && rm -rf /var/lib/apt/lists/*;
RUN curl -f --silent --location https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;

WORKDIR /root/coriolis-web

ADD ./ .

RUN yarn install --production --no-progress && yarn cache clean;
RUN yarn build

ENTRYPOINT [ "yarn", "start" ]
EXPOSE 3000
