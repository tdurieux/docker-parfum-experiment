FROM node:10.24.1-buster-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl openssl ca-certificates git python build-essential && \
    rm -rf /var/lib/apt/lists/* && \
    npm config set unsafe-perm true && \
    npm install mocha -g --loglevel=error && npm cache clean --force;

ENV NODE_ENV=production

COPY . /app

WORKDIR /app

RUN npm install --save chai && npm cache clean --force;

ENTRYPOINT ["mocha"]
CMD ["test/selenium/Scenario/newUser.js"]
