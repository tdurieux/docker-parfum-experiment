FROM nginx:latest

ADD ./default.conf /etc/nginx/conf.d/default.conf
ADD ./html /code

EXPOSE 80