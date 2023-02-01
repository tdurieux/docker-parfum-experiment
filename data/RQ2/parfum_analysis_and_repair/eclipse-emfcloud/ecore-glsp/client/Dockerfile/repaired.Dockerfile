FROM node:12.22.9-alpine3.15

RUN mkdir /usr/src/client -p && rm -rf /usr/src/client

WORKDIR /usr/src/client

RUN apk add --no-cache --update python3 && \
	apk add --no-cache --update make && \
	apk add --no-cache --update g++ && \
	apk add --no-cache --update libsecret-dev && \
	apk add --no-cache --update openjdk11-jre

# Have to copy everything because the build statement in theia-ecore starts linting, which requires all files.
# "build": "tsc && yarn run lint"
COPY . .

RUN yarn install && yarn cache clean;

RUN yarn rebuild:browser

WORKDIR ./browser-app

EXPOSE 3000

CMD yarn start --hostname 0.0.0.0