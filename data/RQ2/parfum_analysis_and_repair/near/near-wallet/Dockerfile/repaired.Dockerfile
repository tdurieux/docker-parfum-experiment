FROM phusion/baseimage:0.11 as build

RUN curl -f -o /tmp/node_setup.sh "https://deb.nodesource.com/setup_12.x"
RUN bash /tmp/node_setup.sh
RUN curl -f -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo 'deb https://dl.yarnpkg.com/debian/ stable main' | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g yarn && npm cache clean --force;

# near-wallet
RUN mkdir /near-wallet
COPY . /near-wallet/
WORKDIR /near-wallet
RUN yarn install && yarn cache clean;
RUN NEAR_WALLET_ENV=development yarn run build

# ======================== EXECUTE ==================================
FROM phusion/baseimage:0.11 as run

ENTRYPOINT ["/sbin/my_init", "--"]

RUN curl -f -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo 'deb https://dl.yarnpkg.com/debian/ stable main' | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    nginx && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /var/www/html/wallet
COPY --from=build /near-wallet/packages/frontend/dist /var/www/html/wallet

# nginx
RUN rm /etc/nginx/sites-enabled/default
COPY --from=build /near-wallet/packages/frontend/scripts/wallet.nginx /etc/nginx/sites-enabled/wallet
COPY --from=build /near-wallet/packages/frontend/scripts/init_nginx.sh /etc/my_init.d/
