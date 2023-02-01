FROM node:14-buster-slim
RUN apt-get update && \
    apt-get install --no-install-recommends -y git build-essential python pkg-config libssl-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;
WORKDIR /edumeet
ENV DEBUG=edumeet*,mediasoup*
RUN npm install -g nodemon && \
    npm install -g concurrently && npm cache clean --force;
RUN touch /.yarnrc && mkdir -p /.yarn /.cache/yarn && chmod -R 775 /.yarn /.yarnrc /.cache
CMD concurrently --names "server,app" \
    "cd server && yarn && yarn dev" \
    "cd app && yarn && yarn build && yarn start"
