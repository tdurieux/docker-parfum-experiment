FROM alpine:3.9

RUN apk add --no-cache bind-tools \
	bash \
	memcached 

ADD ./server.sh /

ENTRYPOINT ["/bin/bash", "/server.sh"]