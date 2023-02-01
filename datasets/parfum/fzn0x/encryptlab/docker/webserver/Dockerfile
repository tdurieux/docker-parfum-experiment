FROM nginx:1.13-alpine
RUN rm /etc/nginx/conf.d/default.conf
COPY docker/conf/nginx/nginx.conf /etc/nginx/conf.d
COPY docker/conf/nginx/gzip.conf /etc/nginx/conf.d
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
