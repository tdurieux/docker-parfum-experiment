FROM nginx:latest
COPY ./dist /usr/share/nginx/html
COPY ./app.conf /etc/nginx/conf.d/app.conf