FROM node:latest
RUN npm install -g npm && \
    npm install -g cnpm --registry=https://registry.npm.taobao.org && \
    cnpm -v && npm cache clean --force;
WORKDIR /var/www/laravel/laraveladmin


