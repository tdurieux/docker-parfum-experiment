FROM node:16-alpine
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait
RUN apk add --no-cache $(apk search --no-cache --no-progress -q "postgresql[[:digit:]]*-client" | sort | tail -n1)
RUN chmod +x /wait
RUN mkdir -p /srv/aurora
RUN mkdir -p /srv/aurora/.near-credentials/mainnet
RUN mkdir -p /srv/aurora/.near-credentials/testnet
RUN mkdir -p /srv/aurora/.near-credentials/betanet
RUN ln -s testnet /srv/aurora/.near-credentials/default
RUN mkdir -p /srv/aurora/relayer
RUN chown -R node:node /srv/aurora
WORKDIR /srv/aurora/relayer
COPY --chown=node:node package*.json ./
USER node
RUN npm ci --only=production
COPY --chown=node:node . .
CMD /wait && node lib/index.js
EXPOSE 8545