FROM splatform/stratos-nginx-base:leap15_2

RUN mkdir -p /etc/secrets/ && \
  openssl req -batch -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout /etc/secrets/server.key -out /etc/secrets/server.crt && \
  chmod 0600 /etc/secrets && \
  chmod 0600 /etc/secrets/server.key && \
  chmod 0600 /etc/secrets/server.crt

COPY ./conf/nginx.dev.conf /etc/nginx/nginx.conf
COPY dist  /usr/share/nginx/html

EXPOSE 80 443
CMD [ "nginx", "-g", "daemon off;" ]