FROM arm32v7/alpine:3.11

LABEL org.opencontainers.image.authors="Tobias Hargesheimer <docker@ison.ws>" \
	org.opencontainers.image.title="NGINX" \
	org.opencontainers.image.description="AlpineLinux 3.11 with NGINX 1.16 on arm arch" \
	org.opencontainers.image.licenses="Apache-2.0" \
	org.opencontainers.image.url="https://hub.docker.com/r/tobi312/rpi-nginx/" \
	org.opencontainers.image.source="https://github.com/Tob1asDocker/rpi-nginx"

ENV NGINX_VERSION 1.16

RUN apk --no-cache add nginx>${NGINX_VERSION} \
	&& mkdir -p /run/nginx \
	&& sed -i "s/ssl_session_cache shared:SSL:2m;/#ssl_session_cache shared:SSL:2m;/g" /etc/nginx/nginx.conf

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log
	
# fix: *** stack smashing detected ***: nginx: worker process terminated / [alert] 9#9: worker process *process-id* exited on signal 6
#RUN sed -i "s/worker_processes auto;/worker_processes 1;/g" /etc/nginx/nginx.conf
	
EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
