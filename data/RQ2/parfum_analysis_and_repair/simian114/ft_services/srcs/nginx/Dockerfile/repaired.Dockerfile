FROM alpine:latest
COPY srcs/self-signed.conf /etc/nginx/snippets/
COPY srcs/ssl-params.conf /etc/nginx/snippets/
RUN apk update; \
	apk add --no-cache nginx openssl; \
	apk add --no-cache openssh
RUN openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=Company, Inc./CN=localhost" -addext "subjectAltName=DNS:localhost" -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
COPY srcs/nginx.conf /etc/nginx/.
COPY srcs/index.html /var/www/html/
COPY srcs/run.sh /


RUN adduser -D sanam
RUN echo "sanam:1234"|chpasswd
RUN mkdir -p /run/nginx
EXPOSE 80 443 22
ENTRYPOINT ["sh", "./run.sh"]
