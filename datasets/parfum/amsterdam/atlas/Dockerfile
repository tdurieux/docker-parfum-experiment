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
FROM nginx:stable-alpine

ARG ENVIRONMENT=prod

COPY scripts/startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx.csp.${ENVIRONMENT}.conf /etc/nginx/conf.d/csp.conf
COPY default.conf /etc/nginx/conf.d/

COPY --from=build-deps /app/dist /usr/share/nginx/html

CMD ["/usr/local/bin/startup.sh"]
