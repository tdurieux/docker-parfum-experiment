# syntax=docker/dockerfile-upstream:experimental

FROM phusion/baseimage:0.11 as build

RUN curl -o /tmp/node_setup.sh "https://deb.nodesource.com/setup_12.x"
RUN bash /tmp/node_setup.sh
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo 'deb https://dl.yarnpkg.com/debian/ stable main' | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y \
    nodejs
RUN npm install -g yarn

# near-wallet
RUN mkdir /near-wallet
COPY . /near-wallet/
WORKDIR /near-wallet
RUN yarn install
RUN NEAR_WALLET_ENV=development yarn run build

# ======================== EXECUTE ==================================
FROM phusion/baseimage:0.11 as run

ENTRYPOINT ["/sbin/my_init", "--"]

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo 'deb https://dl.yarnpkg.com/debian/ stable main' | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y \
    nginx

RUN mkdir -p /var/www/html/wallet
COPY --from=build /near-wallet/packages/frontend/dist /var/www/html/wallet

# nginx
RUN rm /etc/nginx/sites-enabled/default
COPY --from=build /near-wallet/packages/frontend/scripts/wallet.nginx /etc/nginx/sites-enabled/wallet
COPY --from=build /near-wallet/packages/frontend/scripts/init_nginx.sh /etc/my_init.d/
