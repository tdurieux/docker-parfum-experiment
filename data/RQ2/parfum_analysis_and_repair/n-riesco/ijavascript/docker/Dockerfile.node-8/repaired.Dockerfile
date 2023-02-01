FROM node:8

RUN apt-get update && \
    apt-get install -yq --no-install-recommends libzmq3-dev jupyter-core jupyter-client jupyter-notebook && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

USER node

WORKDIR /home/node

COPY --chown=node:node . .

RUN rm -rf node_modules && npm install && npm cache clean --force;

CMD npm run test && node bin/ijsinstall.js
