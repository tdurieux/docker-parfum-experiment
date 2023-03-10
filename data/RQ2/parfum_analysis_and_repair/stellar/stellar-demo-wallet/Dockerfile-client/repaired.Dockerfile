FROM node:16 as build

MAINTAINER SDF Ops Team <ops@stellar.org>

WORKDIR /app

ARG REACT_APP_CLIENT_DOMAIN
ENV REACT_APP_CLIENT_DOMAIN $REACT_APP_CLIENT_DOMAIN

ARG REACT_APP_WALLET_BACKEND_ENDPOINT
ENV REACT_APP_WALLET_BACKEND_ENDPOINT $REACT_APP_WALLET_BACKEND_ENDPOINT

COPY . /app/
RUN yarn workspace demo-wallet-client install
RUN yarn build:shared && yarn cache clean;
RUN yarn build:client && yarn cache clean;

# Copy the compiled static files out to an Nginx container, since we don't need any of the Node files.
FROM nginx:1.17
COPY --from=build /app/packages/demo-wallet-client/build/ /usr/share/nginx/html/
COPY --from=build /app/nginx.conf /etc/nginx/conf.d/default.conf
