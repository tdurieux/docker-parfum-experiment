FROM amd64/alpine:latest

RUN apk update && \
	apk upgrade && \
	apk add --no-cache ca-certificates mailcap && \
	rm -rf /var/cache/apk/* && \
	echo 'hosts: files dns' >| /etc/nsswitch.conf

LABEL maintainer="ownCloud GmbH <devops@owncloud.com>" \
  org.label-schema.name="oCIS Store" \
  org.label-schema.vendor="ownCloud GmbH" \
  org.label-schema.schema-version="1.0"

EXPOSE 9460

ENTRYPOINT ["/usr/bin/ocis-store"]
CMD ["server"]

COPY bin/ocis-store /usr/bin/ocis-store
