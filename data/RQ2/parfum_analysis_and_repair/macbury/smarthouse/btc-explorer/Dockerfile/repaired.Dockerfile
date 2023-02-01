FROM node:8 as builder

RUN apt-get -yqq --no-install-recommends install git \
    && git clone --depth 1 --single-branch --branch master https://github.com/janoside/btc-rpc-explorer \
    && cd /btc-rpc-explorer \
    && npm install && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

FROM node:8-alpine
WORKDIR /btc-rpc-explorer
COPY --from=builder /btc-rpc-explorer .
CMD npm start
EXPOSE 3002