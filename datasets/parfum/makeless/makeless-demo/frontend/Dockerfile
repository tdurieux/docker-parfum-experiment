FROM node:16 as build

WORKDIR /makeless-ui
COPY ./makeless.json /makeless-ui
COPY ./frontend /makeless-ui

RUN yarn install
RUN yarn build

FROM httpd:2.4
COPY --from=build /makeless-ui/dist /usr/local/apache2/htdocs/
COPY --from=build /makeless-ui/.htaccess /usr/local/apache2/htdocs/.htaccess

RUN sed -i '/<Directory "\/usr\/local\/apache2\/htdocs">/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' conf/httpd.conf

