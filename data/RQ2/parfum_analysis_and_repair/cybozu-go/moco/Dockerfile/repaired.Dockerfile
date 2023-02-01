# Build the moco-controller binary
FROM quay.io/cybozu/golang:1.17-focal as builder

# Copy the go source
COPY ./ .

# Build
RUN CGO_ENABLED=0 go build -ldflags="-w -s" -o moco-controller ./cmd/moco-controller
RUN go build -ldflags="-w -s" -o moco-backup ./cmd/moco-backup

# the controller image
FROM scratch as controller
LABEL org.opencontainers.image.source https://github.com/cybozu-go/moco

COPY --from=builder /work/moco-controller ./
USER 10000:10000

ENTRYPOINT ["/moco-controller"]

# For MySQL binaries
FROM quay.io/cybozu/mysql:8.0.28.1 as mysql

# the backup image