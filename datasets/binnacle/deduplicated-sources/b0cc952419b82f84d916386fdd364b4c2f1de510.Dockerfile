FROM apendergast/ceg-docker-base:rpi-gateway-latest as gateway
FROM apendergast/ceg-docker-base:rpi-ui-latest as ui
COPY --from=gateway /root/dummy /root/dummy
RUN [ "cross-build-start" ]
WORKDIR /root/
ARG GIT_BRANCH=master
ARG TIMESTAMP=0
# build gateway
RUN echo "$TIMESTAMP" && git clone https://github.com/aloysius-pgast/crypto-exchanges-gateway.git && cd crypto-exchanges-gateway && \
    git checkout $GIT_BRANCH && \
    cp -R /root/dummy/gateway/node_modules . && npm install --unsafe-perm && \
    cp docker/config.docker.json config/config.json
# build ui
RUN cd crypto-exchanges-gateway/ui && \
    cp -R /root/dummy/ui/node_modules . && npm install --unsafe-perm && npm run build && rm -fr node_modules
RUN [ "cross-build-end" ]

FROM apendergast/alpine-node:rpi-runtime-latest
RUN [ "cross-build-start" ]
WORKDIR /root/crypto-exchanges-gateway/
COPY --from=ui /root/crypto-exchanges-gateway .

VOLUME ["/root/crypto-exchanges-gateway/ssl","/root/crypto-exchanges-gateway/storage/db","/root/crypto-exchanges-gateway/custom_config"]

ENV cfg.auth.apikey ""
ENV cfg.listen.externalEndpoint ""
ENV cfg.listenWs.externalEndpoint ""
ENV cfg.sessions.maxSubscriptions "0"
ENV cfg.sessions.maxDuration "0"
ENV cfg.pushover.user ""
ENV cfg.pushover.token ""
ENV cfg.tickerMonitor.enabled "1"
ENV cfg.marketCap.enabled "1"
ENV cfg.fxConverter.enabled "1"
ENV cfg.exchanges.poloniex.enabled "1"
ENV cfg.exchanges.poloniex.key ""
ENV cfg.exchanges.poloniex.secret ""
ENV cfg.exchanges.bittrex.enabled "1"
ENV cfg.exchanges.bittrex.key ""
ENV cfg.exchanges.bittrex.secret ""
ENV cfg.exchanges.binance.enabled "1"
ENV cfg.exchanges.binance.requirePair "0"
ENV cfg.exchanges.binance.key ""
ENV cfg.exchanges.binance.secret ""
ENV cfg.exchanges.kucoin.enabled "1"
ENV cfg.exchanges.kucoin.requirePair "0"
ENV cfg.exchanges.kucoin.key ""
ENV cfg.exchanges.kucoin.secret ""
ENV cfg.exchanges.okex.enabled "1"
ENV cfg.exchanges.okex.requirePair "0"
ENV cfg.exchanges.okex.key ""
ENV cfg.exchanges.okex.secret ""

EXPOSE 8000
EXPOSE 8001
CMD ["node", "./gateway.js"]
RUN [ "cross-build-end" ]
