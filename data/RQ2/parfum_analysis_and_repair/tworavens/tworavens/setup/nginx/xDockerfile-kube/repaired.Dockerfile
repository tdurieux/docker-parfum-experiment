FROM nginx

ADD ./nginx-kube.conf /etc/nginx/nginx.conf

VOLUME /ravens_volume