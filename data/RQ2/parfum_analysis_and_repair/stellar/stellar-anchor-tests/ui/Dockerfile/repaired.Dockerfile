FROM ubuntu:20.04 as build

MAINTAINER SDF Ops Team <ops@stellar.org>

ARG SERVER_HOST
ENV REACT_APP_SERVER_HOST=$SERVER_HOST

ARG REACT_APP_AMPLITUDE_KEY
ENV REACT_APP_AMPLITUDE_KEY $REACT_APP_AMPLITUDE_KEY

ARG REACT_APP_SENTRY_KEY
ENV REACT_APP_SENTRY_KEY $REACT_APP_SENTRY_KEY

RUN mkdir -p /app/ui
RUN apt-get update && apt-get install --no-install-recommends -y gnupg1 libtool build-essential && rm -rf /var/lib/apt/lists/*;

WORKDIR /app


RUN apt-get update && apt-get install --no-install-recommends -y gnupg curl git make apt-transport-https && \
    curl -f -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    echo "deb https://deb.nodesource.com/node_14.x focal main" | tee /etc/apt/sources.list.d/nodesource.list && \
    curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install --no-install-recommends -y nodejs yarn && apt-get clean && rm -rf /var/lib/apt/lists/*;

COPY tsconfig.json package.json yarn.lock /app/
COPY ./ui /app/ui/
RUN yarn install && yarn cache clean;
RUN yarn workspace ui build && yarn cache clean;

FROM nginx:1.17

COPY --from=build /app/ui/build/ /usr/share/nginx/html/
COPY --from=build /app/ui/nginx.conf /etc/nginx/conf.d/default.conf
