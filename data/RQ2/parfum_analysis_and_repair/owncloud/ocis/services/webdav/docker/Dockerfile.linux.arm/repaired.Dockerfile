FROM arm32v6/alpine:latest

RUN apk update && \
	apk upgrade && \
	apk add --no-cache ca-certificates mailcap && \
	rm -rf /var/cache/apk/* && \
	echo 'hosts: files dns' >| /etc/nsswitch.conf

LABEL maintainer="ownCloud GmbH <devops@owncloud.com>" \
  org.label-schema.name="oCIS WebDAV" \
  org.label-schema.vendor="ownCloud GmbH" \
  org.label-schema.schema-version="1.0"

EXPOSE 9115 9119

ENTRYPOINT ["/usr/bin/ocis-webdav"]
CMD ["server"]

COPY bin/ocis-webdav /usr/bin/ocis-webdav
