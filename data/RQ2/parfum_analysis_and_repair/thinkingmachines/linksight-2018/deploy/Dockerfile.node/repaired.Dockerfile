FROM node:8-alpine
WORKDIR /usr/src/app
COPY app/package.json /usr/src/app/
COPY app/package-lock.json /usr/src/app/
RUN apk --update --no-cache add --virtual .build-deps \
        make automake libtool gcc autoconf musl-dev libpng-dev && \
    npm install && \
    apk --purge del .build-deps && npm cache clean --force;
COPY app /usr/src/app
ARG PUBLIC_URL
RUN npm run build
