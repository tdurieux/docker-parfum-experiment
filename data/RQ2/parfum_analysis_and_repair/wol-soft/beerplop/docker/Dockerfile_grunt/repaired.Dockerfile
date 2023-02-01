FROM node:12

WORKDIR /var/www/beerplop/

RUN npm install -g grunt-cli grunt sass \
    && apt-get update \
    && apt-get install --no-install-recommends ruby -y && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;