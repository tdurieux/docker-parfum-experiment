FROM alpine:3.4

RUN apk update \
  && apk --update --no-cache add nodejs

RUN mkdir -p /react
WORKDIR /react

# キャッシュ効率を上げるためにまずpackage.jsonだけcopyしてnpm installする
COPY ./package.json npm-shrinkwrap.json /react/
RUN npm install && npm cache clean --force

COPY . /react

RUN NODE_ENV=production npm run build

CMD ["node", "build/server.js"]
