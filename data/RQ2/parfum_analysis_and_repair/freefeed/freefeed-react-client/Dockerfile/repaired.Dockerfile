FROM node:14 as builder

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    g++ \
    git \
    make && rm -rf /var/lib/apt/lists/*;

ADD . /client
WORKDIR /client

RUN rm -rf node_modules && \
    rm -f log/*.log && \
    yarn install && \
    yarn build-prod && yarn cache clean;

FROM scratch

COPY --from=builder /client/_dist /var/www/freefeed-react-client
VOLUME /var/www/freefeed-react-client
