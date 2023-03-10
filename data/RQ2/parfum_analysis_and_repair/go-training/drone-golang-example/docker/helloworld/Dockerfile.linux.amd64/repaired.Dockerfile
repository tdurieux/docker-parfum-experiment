FROM plugins/base:linux-amd64

LABEL maintainer="Bo-Yi Wu <appleboy.tw@gmail.com>" \
  org.label-schema.name="helloworld" \
  org.label-schema.vendor="Bo-Yi Wu" \
  org.label-schema.schema-version="1.0"

EXPOSE 8080

COPY release/linux/amd64/helloworld /bin/

ENTRYPOINT ["/bin/helloworld"]