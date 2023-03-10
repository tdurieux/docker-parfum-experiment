FROM node:lts-alpine as trading-view-${jenkinsPlatform}
ARG trading_view_token
WORKDIR /root
RUN echo "//registry.npmjs.org/:_authToken=\$trading_view_token" > /root/.npmrc && \
    npm i @waves/trading-view && npm cache clean --force;

FROM node:lts-alpine as static-${jenkinsPlatform}
RUN apk update && apk add --no-cache git

COPY ./WavesGUI/ /srv/www/WavesGUI/
WORKDIR /srv/www/WavesGUI
ARG platform=web
RUN npm ci --unsafe-perm && \
    node_modules/.bin/gulp build --platform \$platform --config ./configs/testnet.json && \
    mv ./dist/\$platform/testnet ./testnet && \
    node_modules/.bin/gulp build --platform \$platform --config ./configs/stagenet.json && \
    mv ./dist/\$platform/stagenet ./stagenet && \
    node_modules/.bin/gulp build --platform \$platform --config ./configs/mainnet.json && \
    mv ./testnet ./dist/\$platform/testnet  && \
    mv ./stagenet ./dist/\$platform/stagenet
RUN rm -rf /srv/www/WavesGUI/node_modules/

FROM nginx:stable-alpine
ARG web_environment=mainnet
ARG platform=web
ENV WEB_ENVIRONMENT=\$web_environment
ENV PLATFORM=\$platform

RUN mkdir -p /etc/nginx/sites-enabled && \
    apk update && \
    apk add --no-cache gettext libintl
WORKDIR /srv/www
COPY --from=trading-view-${jenkinsPlatform} /root/node_modules node_modules
COPY --from=static-${jenkinsPlatform} /srv/www .
COPY ./nginx/default.conf /etc/nginx/sites-available/default.conf
COPY ./info.html /srv/www/info
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./files/ /srv/www/WavesGUI/dist/web/mainnet/
EXPOSE 80

CMD ["/bin/sh","-c", "envsubst '\${WEB_ENVIRONMENT}' < /etc/nginx/sites-available/default.conf > /etc/nginx/sites-enabled/\${PLATFORM}-\${WEB_ENVIRONMENT}.conf ; envsubst '\${WEB_ENVIRONMENT}' < /srv/www/info > /srv/www/info.html ; nginx -g 'daemon off;'"]
