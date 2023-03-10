FROM alpine:latest as certs
RUN apk --update --no-cache add ca-certificates


FROM scratch
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY envoy-oidc-filter /
ENTRYPOINT ["/envoy-oidc-filter"]
