FROM amd64/alpine:latest

RUN apk update && \
	apk upgrade && \
	apk add --no-cache ca-certificates mailcap && \
	rm -rf /var/cache/apk/* && \
	echo 'hosts: files dns' >| /etc/nsswitch.conf

LABEL maintainer="ownCloud GmbH <devops@owncloud.com>" \
  org.label-schema.name="oCIS Graph-Explorer" \
  org.label-schema.vendor="ownCloud GmbH" \
  org.label-schema.schema-version="1.0"

EXPOSE 9100 9104

ENTRYPOINT ["/usr/bin/ocis-graph-explorer"]
CMD ["server"]

COPY bin/ocis-graph-explorer /usr/bin/ocis-graph-explorer
