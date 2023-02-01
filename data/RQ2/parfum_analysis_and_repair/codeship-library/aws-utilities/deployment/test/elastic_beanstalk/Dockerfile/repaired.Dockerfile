FROM ubuntu:20.04

EXPOSE 80

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		nginx \
	&& echo "daemon off;" >> /etc/nginx/nginx.conf && rm -rf /var/lib/apt/lists/*;

COPY index.html /var/www/html/

CMD ["/usr/sbin/nginx", "-c", "/etc/nginx/nginx.conf"]
