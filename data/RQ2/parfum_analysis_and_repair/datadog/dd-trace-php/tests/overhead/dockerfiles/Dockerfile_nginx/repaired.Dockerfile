FROM nginx:1.17.5-alpine

ADD ./tests/overhead/dockerfiles/default.conf /etc/nginx/conf.d/default.conf
ADD ./tests/overhead/Laravel57 /var/www