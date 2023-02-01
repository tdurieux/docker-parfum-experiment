FROM node:10

RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && apt-get update \
    && apt-get install --no-install-recommends -y apt-transport-https \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y yarn git make curl zip \
    && mkdir -p /app && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn install && yarn cache clean;
COPY . .

EXPOSE 8080

COPY .docker/node/startup.sh /
RUN chmod +x /startup.sh

ENTRYPOINT ["/startup.sh"]
