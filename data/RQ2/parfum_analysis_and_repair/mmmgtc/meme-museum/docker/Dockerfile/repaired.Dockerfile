FROM ubuntu:20.04

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y software-properties-common && \
  apt-get install --no-install-recommends -y wget make curl git && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;

VOLUME /var/www

WORKDIR /var/www/html

EXPOSE 3000


ADD ./package.json ./yarn.*
RUN yarn install && yarn cache clean;

