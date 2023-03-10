FROM plugins/base:linux-amd64

LABEL maintainer="Bo-Yi Wu <appleboy.tw@gmail.com>" \
  org.label-schema.name="ggz-redirect" \
  org.label-schema.vendor="Bo-Yi Wu" \
  org.label-schema.schema-version="1.0"

EXPOSE 8081

COPY release/linux/amd64/ggz-redirect /bin/

HEALTHCHECK --start-period=2s --interval=10s --timeout=5s \
  CMD ["/bin/ggz-redirect", "health"]

ENTRYPOINT ["/bin/ggz-redirect"]
CMD ["server"]