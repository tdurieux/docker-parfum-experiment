FROM arm32v7/debian:stretch-slim

LABEL org.opencontainers.image.authors="Tobias Hargesheimer <docker@ison.ws>" \
	org.opencontainers.image.title="NGINX" \
	org.opencontainers.image.description="Debian 9 Stretch with NGINX 1.10 on arm arch" \
	org.opencontainers.image.licenses="Apache-2.0" \
	org.opencontainers.image.url="https://hub.docker.com/r/tobi312/rpi-nginx/" \
	org.opencontainers.image.source="https://github.com/Tob1asDocker/rpi-nginx"

ENV NGINX_VERSION 1.10.*

RUN apt-get update \
	&& apt-get install -y ca-certificates nginx=${NGINX_VERSION} \
	&& rm -rf /var/lib/apt/lists/*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log
	
# fix: *** stack smashing detected ***: nginx: worker process terminated / [alert] 9#9: worker process *process-id* exited on signal 6
RUN sed -i "s/worker_processes auto;/worker_processes 1;/g" /etc/nginx/nginx.conf
	
EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
