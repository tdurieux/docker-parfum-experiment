FROM node:0.12

RUN apt-get update && \
    apt-get install -yq --no-install-recommends libzmq3-dev ipython-notebook && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

USER node

WORKDIR /home/node

COPY --chown=node:node . .

RUN rm -rf node_modules && npm install --save jp-kernel@1 jmp@1 && npm install && npm cache clean --force;

CMD npm run test:ijskernel; bin/ijsinstall.js
