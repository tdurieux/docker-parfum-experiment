FROM node:7.7-slim

# yarn things
RUN apt-get update && \
    apt-get install --no-install-recommends -y apt-transport-https && \
    curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
    apt-get install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp/app
COPY . .

RUN yarn && yarn cache clean;
RUN npm run bundle:min
