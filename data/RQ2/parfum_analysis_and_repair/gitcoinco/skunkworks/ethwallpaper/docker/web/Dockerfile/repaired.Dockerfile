FROM ubuntu:16.04

COPY ./docker/web/web-entrypoint.sh /
COPY ./frontend/package.json /django/package.json

WORKDIR /django

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -

RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install --no-install-recommends -y nodejs yarn && rm -rf /var/lib/apt/lists/*;

RUN yarn && yarn cache clean;
