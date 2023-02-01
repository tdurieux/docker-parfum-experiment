FROM node:12.16.1-alpine3.11 as BUILD
RUN apk add --no-cache \
	gcc \
    g++ \
	make \
    linux-headers \
    udev \
    python3
RUN npm install -g npm@7 && npm cache clean --force;

## change it to maintain all the dev dependencies
ARG BUILD_ENV=production
WORKDIR /app
COPY ./package.json ./
COPY ./tsconfig.json ./
COPY ./packages packages/

RUN npm install && npm run build && npm cache clean --force;

# now remove dev dependencies by reinstalling for production
# this wil reduce the size of the image built in next steps significantly
RUN if [ "${BUILD_ENV}" = "production" ]; then npm prune --production; fi

FROM node:12.16.1-alpine3.11

COPY --from=BUILD  /app /app

WORKDIR /app/packages/cli

EXPOSE 8080/tcp
EXPOSE 5683/udp

STOPSIGNAL SIGINT

ENTRYPOINT [ "node", "dist/cli.js" ]
CMD [ "-h" ]

##  docker build -t wot-servient ./docker/Dockerfile
