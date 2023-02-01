FROM node:16
ENV NODE_ENV production

WORKDIR /app

# https://github.com/kkarczmarczyk/docker-node-yarn/blob/master/latest/Dockerfile
RUN apt-get update && apt-get install --no-install-recommends -y curl apt-transport-https && \
    curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y gcc g++ unzip apt-utils libcairo2-dev libpango1.0-dev build-essential default-jdk && rm -rf /var/lib/apt/lists/*;

RUN npm install -g pm2 && npm cache clean --force;

COPY package*.json ./
COPY yarn.lock ./

RUN yarn install --production && mv node_modules ../ && yarn cache clean;

COPY . .

EXPOSE 3000

RUN node manage.js
CMD ["npx", "pm2", "start", "pm2.config.json", "--no-daemon"]
