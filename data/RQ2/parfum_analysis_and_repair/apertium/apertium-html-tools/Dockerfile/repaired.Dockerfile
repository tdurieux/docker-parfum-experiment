FROM node:14-buster-slim
LABEL maintainer sushain@skc.name
WORKDIR /root

RUN apt-get -qq update && \
    apt-get -qq -y install --no-install-recommends git && rm -rf /var/lib/apt/lists/*;

COPY package.json .
COPY yarn.lock .
RUN yarn install --dev && yarn cache clean;

COPY . .

ENTRYPOINT ["yarn"]
CMD ["build", "--prod"]
