FROM ghcr.io/openfaas/classic-watchdog:0.2.0 as watchdog

FROM node:6.9.1-alpine

COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
RUN chmod +x /usr/bin/fwatchdog

WORKDIR /application/

COPY package.json .

RUN npm i && npm cache clean --force;
COPY handler.js .

USER 1000

ENV fprocess="node handler.js"

HEALTHCHECK --interval=1s CMD [ -e /tmp/.lock ] || exit 1

CMD ["fwatchdog"]

