FROM plugins/base:linux-amd64

LABEL maintainer="Bo-Yi Wu <appleboy.tw@gmail.com>" \
  org.label-schema.name="ggz-server" \
  org.label-schema.vendor="Bo-Yi Wu" \
  org.label-schema.schema-version="1.0"

EXPOSE 8080

COPY release/linux/amd64/ggz-server /bin/

HEALTHCHECK --start-period=2s --interval=10s --timeout=5s \
  CMD ["/bin/ggz-server", "health"]

ENTRYPOINT ["/bin/ggz-server"]
CMD ["server"]