FROM nginx:stable-alpine

EXPOSE 80

COPY nginx/nginx.conf /etc/nginx/
COPY nginx/default.conf /etc/nginx/conf.d/

RUN rm -rf /usr/share/nginx/html/*

COPY ./frontend/ /usr/share/nginx/html
RUN chown -R nginx:nginx /usr/share/nginx/html/

COPY docker-write-api-file.sh /docker-entrypoint.d/

RUN chmod +x /docker-entrypoint.d/docker-write-api-file.sh && apk add --no-cache jq

CMD ["nginx", "-g", "daemon off;"]
