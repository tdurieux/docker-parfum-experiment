FROM nginx:1.13

ARG NGINX_TMPL

# Add start script
ADD nginx-start.sh /
RUN chmod +x nginx-start.sh

# Add nginx config file
ADD ${NGINX_TMPL} /

# Add SSL certs to location specified in nginx.conf
ADD *.crt /etc/ssl/certs/
ADD *.key /etc/ssl/private/

CMD ["./nginx-start.sh"]
