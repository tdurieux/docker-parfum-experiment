################################
# Base
################################
FROM node:16.15.0 AS build-deps
LABEL maintainer="datapunt@amsterdam.nl"

WORKDIR /app

COPY public ./public

COPY package.json package-lock.json ./

RUN git config --global url."https://".insteadOf git:// && \
    git config --global url."https://github.com/".insteadOf git@github.com:

RUN npm ci && \
    npm cache clean --force

COPY .browserslistrc \
    index.ejs \
    webpack.* \
    tsconfig.* \
    favicon.png \
    ./

COPY src ./src

RUN npm run build

RUN echo "`date`" > ./dist/version.txt

################################
# Deploy
################################