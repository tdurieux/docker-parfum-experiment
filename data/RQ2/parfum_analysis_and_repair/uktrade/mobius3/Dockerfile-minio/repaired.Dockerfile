FROM minio/minio:RELEASE.2019-12-30T05-45-39Z

RUN \
	apk add --no-cache \
		openssl

COPY minio-entrypoint.sh /

ENTRYPOINT ["/minio-entrypoint.sh"]
CMD ["server", "/test-data"]