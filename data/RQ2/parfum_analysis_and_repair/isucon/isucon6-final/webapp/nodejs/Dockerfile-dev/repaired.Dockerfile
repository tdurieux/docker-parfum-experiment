FROM alpine:3.4

RUN apk update \
  && apk --update --no-cache add nodejs

RUN mkdir -p /app
WORKDIR /app

RUN npm install -g nodemon && npm cache clean --force;

# キャッシュ効率を上げるためにまずpackage.jsonだけcopyしてnpm installする
COPY ./package.json /app/
RUN npm install && npm cache clean --force

CMD ["nodemon", "--watch", "/app/", "--exec", "/app/bin/run"]
