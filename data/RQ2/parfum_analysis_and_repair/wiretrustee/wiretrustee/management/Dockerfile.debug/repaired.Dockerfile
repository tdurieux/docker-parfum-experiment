FROM gcr.io/distroless/base:debug
ENTRYPOINT [ "/go/bin/netbird-mgmt","management","--log-level","debug"]
CMD ["--log-file", "console"]
COPY netbird-mgmt /go/bin/netbird-mgmt