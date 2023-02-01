FROM dockerxman/docker-ubuntu-ssh:latest
LABEL MAINTAINER xuexb <fe.xiaowu@gmail.com>

RUN mkdir -p /root/app
WORKDIR /root/app

RUN apt-get update && apt-get -y --no-install-recommends -q install nginx && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

STOPSIGNAL SIGTERM

EXPOSE 80
EXPOSE 22

CMD [ "/root/entrypoint.sh" ]