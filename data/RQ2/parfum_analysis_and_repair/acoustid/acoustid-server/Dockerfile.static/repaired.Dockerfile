FROM nginx:alpine

COPY admin/nginx-static.conf /etc/nginx/conf.d/default.conf
COPY acoustid/web/static/ /opt/acoustid/server/acoustid/web/static/