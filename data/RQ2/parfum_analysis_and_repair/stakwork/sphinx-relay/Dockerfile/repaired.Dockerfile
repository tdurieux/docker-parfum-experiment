FROM node:12-buster-slim AS builder

WORKDIR /relay
RUN mkdir /relay/.lnd
COPY --chown=1000:1000 . .

RUN apt-get update

RUN apt install --no-install-recommends -y make python-minimal && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y g++ gcc libmcrypt-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

RUN rm ./package-lock.json

RUN npm install bcrypt && npm cache clean --force;
RUN npm install && npm cache clean --force;

RUN cp /relay/config/app.json /relay/dist/config/app.json
RUN cp /relay/config/config.json /relay/dist/config/config.json

RUN chown -R 1000:1000 /relay

FROM node:12-buster-slim

USER 1000

WORKDIR /relay

COPY --from=builder /relay .

EXPOSE 3300

ENV NODE_ENV production
ENV NODE_SCHEME http
ENV PORT 3300

CMD [ "node", "/relay/dist/app.js" ]
