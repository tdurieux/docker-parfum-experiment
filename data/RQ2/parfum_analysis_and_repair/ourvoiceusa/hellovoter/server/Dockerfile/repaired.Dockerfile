FROM node:erbium as node
FROM ourvoiceusa/neo4j-hv
COPY --from=node /usr/local/ /usr/local/
RUN apt-get update && apt-get install --no-install-recommends -y git && apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /node

COPY .babelrc .
COPY package.json .
COPY package-lock.json .
COPY patches ./patches/

RUN npm --unsafe-perm install && npm cache clean --force;

ENV NODE_ENV=production
ENV BABEL_CACHE_PATH=/tmp/.babel_cache
ENV NO_UPDATE_NOTIFIER=1
ENV DISABLE_JMX=1

EXPOSE 8080
EXPOSE 8443

HEALTHCHECK --interval=15s --timeout=5s --start-period=5s CMD node /node/app/poke.js

COPY start.sh /start.sh
COPY scripts scripts
COPY app app

CMD [ "/start.sh" ]
