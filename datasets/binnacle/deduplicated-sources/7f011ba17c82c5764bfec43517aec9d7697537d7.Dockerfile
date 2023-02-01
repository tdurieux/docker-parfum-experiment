FROM golang:1.12-stretch AS builder

# Download tools
RUN wget -O $GOPATH/bin/dep https://github.com/golang/dep/releases/download/v0.5.0/dep-linux-amd64
RUN chmod +x $GOPATH/bin/dep

# Copy sources
WORKDIR $GOPATH/src/github.com/pusher/oauth2_proxy
COPY . .

# Fetch dependencies
RUN dep ensure --vendor-only

# Build binary and make sure there is at least an empty key file.
#  This is useful for GCP App Engine custom runtime builds, because
#  you cannot use multiline variables in their app.yaml, so you have to
#  build the key into the container and then tell it where it is
#  by setting OAUTH2_PROXY_JWT_KEY_FILE=/etc/ssl/private/jwt_signing_key.pem
#  in app.yaml instead.
RUN ./configure && GOARCH=arm64 make build && touch jwt_signing_key.pem

# Copy binary to alpine
FROM arm64v8/alpine:3.9
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /go/src/github.com/pusher/oauth2_proxy/oauth2_proxy /bin/oauth2_proxy
COPY --from=builder /go/src/github.com/pusher/oauth2_proxy/jwt_signing_key.pem /etc/ssl/private/jwt_signing_key.pem

USER 2000:2000

ENTRYPOINT ["/bin/oauth2_proxy"]
