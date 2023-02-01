FROM alpine

WORKDIR /root/
RUN apk update \
	&& apk add --no-cache bash wget tar gzip && \
	rm -rf /var/cache/apk/* && \
	echo done