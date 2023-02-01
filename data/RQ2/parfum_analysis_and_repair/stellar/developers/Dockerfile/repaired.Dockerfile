FROM ubuntu:20.04 as build

MAINTAINER SDF Ops Team <ops@stellar.org>

ADD . /app/src

WORKDIR /app/src

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y gpg curl git make ca-certificates gcc g++ apt-transport-https && \
    curl -f -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --batch --dearmor >/etc/apt/trusted.gpg.d/nodesource.gpg && \
    echo "deb https://deb.nodesource.com/node_10.x focal main" | tee /etc/apt/sources.list.d/nodesource.list && \
    curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --batch --dearmor >/etc/apt/trusted.gpg.d/yarnpkg.gpg && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install --no-install-recommends -y nodejs yarn && rm -rf /var/lib/apt/lists/*;


RUN npm install -q -g gulp && yarn install && rm -rf ./repos/ && \
    gulp --pathPrefix="/developers" && npm cache clean --force; && yarn cache clean;

FROM nginx:1.17

COPY --from=build /app/src/build/ /usr/share/nginx/html/developers
