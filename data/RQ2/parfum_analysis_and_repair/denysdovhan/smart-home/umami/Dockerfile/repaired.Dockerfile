FROM node:12.22

ENV DATABASE_URL="mysql://umami:umami@db:3306/umami"
ENV DATABASE_TYPE=mysql

RUN apt-get -yqq --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

ADD "https://api.github.com/repos/mikecao/umami/releases?per_page=1" latest_commit
RUN git clone --depth 1 --single-branch --branch master https://github.com/mikecao/umami.git /app

WORKDIR /app

RUN yarn install --frozen-lockfile --network-timeout 1000000 && yarn cache clean;
RUN yarn next telemetry disable
RUN yarn build

USER node

EXPOSE 3000
CMD ["yarn", "start"]
