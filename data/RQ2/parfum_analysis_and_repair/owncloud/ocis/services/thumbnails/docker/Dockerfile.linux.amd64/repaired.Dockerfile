FROM amd64/alpine:latest

RUN apk update && \
	apk upgrade && \
	apk add --no-cache ca-certificates mailcap && \
	rm -rf /var/cache/apk/* && \
	echo 'hosts: files dns' >| /etc/nsswitch.conf

LABEL maintainer="ownCloud GmbH <devops@owncloud.com>" \
  org.label-schema.name="oCIS Thumbnails" \
  org.label-schema.vendor="ownCloud GmbH" \
  org.label-schema.schema-version="1.0"

EXPOSE 9110 9114

ENTRYPOINT ["/usr/bin/ocis-thumbnails"]
CMD ["server"]

COPY bin/ocis-thumbnails /usr/bin/ocis-thumbnails
