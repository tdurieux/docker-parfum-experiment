# vim: syntax=dockerfile
FROM gcr.io/distroless/base
COPY zed /usr/local/bin/zed
ENTRYPOINT ["zed"]