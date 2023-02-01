FROM 278380418400.dkr.ecr.eu-west-2.amazonaws.com/setup-tools:latest
FROM 278380418400.dkr.ecr.eu-west-2.amazonaws.com/setup-mpc-common:latest

FROM node:10
WORKDIR /usr/src/setup-mpc-common
COPY --from=1 /usr/src/setup-mpc-common .
RUN yarn link && yarn cache clean;
WORKDIR /usr/src/setup-mpc-client
COPY package.json yarn.lock ./
RUN yarn install && yarn cache clean;
COPY . .
RUN yarn build

FROM ubuntu:latest
RUN apt update && \
  apt install --no-install-recommends -y curl && \
  curl -f -sL https://deb.nodesource.com/setup_10.x | bash - && \
  curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt update && \
  apt install --no-install-recommends -y nodejs yarn && \
  apt clean && rm -rf /var/lib/apt/lists/*;
COPY --from=0 /usr/src/setup-tools/setup /usr/src/setup-tools/setup
COPY --from=0 /usr/src/setup-tools/setup-fast /usr/src/setup-tools/setup-fast
RUN mkdir /usr/src/setup_db && rm -rf /usr/src/setup_db
WORKDIR /usr/src/setup-mpc-common
COPY --from=1 /usr/src/setup-mpc-common .
RUN yarn link && yarn cache clean;
WORKDIR /usr/src/setup-mpc-client
COPY --from=2 /usr/src/setup-mpc-client .
RUN yarn link setup-mpc-common && yarn cache clean;
CMD ["yarn", "--silent", "start"]