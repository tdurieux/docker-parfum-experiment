FROM plugins/base:linux-arm

LABEL maintainer="Bo-Yi Wu <appleboy.tw@gmail.com>" \
  org.label-schema.name="Drone Discord" \
  org.label-schema.vendor="Bo-Yi Wu" \
  org.label-schema.schema-version="1.0"

COPY release/linux/arm/drone-discord /bin/

ENTRYPOINT ["/bin/drone-discord"]