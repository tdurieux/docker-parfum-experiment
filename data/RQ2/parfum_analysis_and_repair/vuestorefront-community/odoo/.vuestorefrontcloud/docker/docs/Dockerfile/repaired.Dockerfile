FROM node:14 AS build

WORKDIR /var/www

COPY . .

RUN cd docs \
  && npm install \
  && sed -i "s/base: '\/',/base: '\/odoo\/',/g" ./.vuepress/config.js \
  && cat ./.vuepress/config.js \
  && npm run build && npm cache clean --force;

FROM nginx

COPY --from=build /var/www/docs/.vuepress/dist /usr/share/nginx/html/odoo
