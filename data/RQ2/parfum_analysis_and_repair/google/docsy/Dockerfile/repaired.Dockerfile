FROM klakegg/hugo:0.95.0-ext-alpine as docsy-user-guide

RUN apk update
RUN apk add --no-cache git
COPY package.json /app/docsy/userguide/
WORKDIR /app/docsy/userguide/
RUN npm install --production=false && npm cache clean --force;

CMD ["serve", "--cleanDestinationDir", "--themesDir ../..", "--baseURL http://localhost:1313/", "--buildDrafts", "--buildFuture", "--disableFastRender", "--ignoreCache", "--watch"]
