FROM alpine:latest

RUN apk add --no-cache nodejs
RUN apk add --no-cache npm
RUN apk add --no-cache openjdk11-jdk

ENV PORT=8080
COPY . /usr/src/yavin

ENV DISABLE_MOCKS=true
WORKDIR /usr/src/yavin
RUN  npm ci -verbose
RUN  node_modules/.bin/lerna bootstrap --hoist --ci --concurrency=2 --loglevel warn
RUN  node_modules/.bin/lerna run build --scope navi-app --stream

WORKDIR /usr/src/yavin/packages/webservice
RUN ./gradlew bootJar -x installUIDependencies
RUN cp -r ./../app/dist app/build/resources/main/META-INF/resources/ui

WORKDIR /
RUN cp /usr/src/yavin/packages/webservice/app/build/libs/app-*.jar /usr/local/lib/
RUN rm -rf /usr/src/yavin
