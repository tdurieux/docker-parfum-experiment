FROM nginx

COPY build/results/docker/Website/ App/
COPY conf/docker/website/ /etc/nginx/

EXPOSE 4200