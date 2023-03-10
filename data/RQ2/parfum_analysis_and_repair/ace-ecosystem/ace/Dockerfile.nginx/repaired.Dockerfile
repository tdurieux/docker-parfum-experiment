FROM nginx:stable-alpine
COPY etc/nginx/ace /etc/nginx/conf.d/default.conf
COPY --from=ace-ssl:latest /ssl /opt/ace/ssl
COPY app/static /opt/ace/app/static