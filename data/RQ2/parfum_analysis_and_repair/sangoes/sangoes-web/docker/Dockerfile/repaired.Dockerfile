FROM nginx:1.15.5

MAINTAINER jerrychir <jerrychir@163.com>

USER root

WORKDIR /usr/src/app/

COPY ./nginx.conf /etc/nginx/conf.d/default.conf

COPY ./dist  /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]