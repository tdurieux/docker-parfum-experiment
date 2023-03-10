FROM arm64v8/alpine:latest

RUN apk update && \
	apk upgrade && \
	apk add --no-cache ca-certificates mailcap && \
	rm -rf /var/cache/apk/* && \
	echo 'hosts: files dns' >| /etc/nsswitch.conf

LABEL maintainer="ownCloud GmbH <devops@owncloud.com>" \
  org.label-schema.name="oCIS LibreGraph Connect" \
  org.label-schema.vendor="ownCloud GmbH" \
  org.label-schema.schema-version="1.0"

EXPOSE 9130 9134

ENTRYPOINT ["/usr/bin/ocis-idp"]
CMD ["server"]

COPY bin/ocis-idp /usr/bin/ocis-idp
