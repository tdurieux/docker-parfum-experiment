FROM gcr.io/distroless/base
COPY dispatchers /go/bin/dispatchers
ENTRYPOINT ["/go/bin/dispatchers"]