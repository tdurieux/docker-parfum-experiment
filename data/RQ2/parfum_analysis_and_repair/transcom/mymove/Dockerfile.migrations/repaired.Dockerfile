FROM alpine:3.15.4

# hadolint ignore=DL3017
RUN apk upgrade --no-cache busybox

COPY config/tls/dod-wcf-root-ca-1.pem /usr/local/share/ca-certificates/dod-wcf-root-ca-1.pem.crt
COPY config/tls/dod-wcf-intermediate-ca-1.pem /usr/local/share/ca-certificates/dod-wcf-intermediate-ca-1.pem.crt

COPY bin/rds-ca-rsa4096-g1.pem /bin/rds-ca-rsa4096-g1.pem
COPY bin/rds-ca-2019-root.pem /bin/rds-ca-2019-root.pem
COPY bin/milmove /bin/milmove

COPY migrations/app/schema /migrate/schema
COPY migrations/app/migrations_manifest.txt /migrate/migrations_manifest.txt

# Install tools needed in container
# hadolint ignore=DL3018
RUN apk update && apk add ca-certificates --no-cache
RUN update-ca-certificates

WORKDIR /

USER nobody

ENTRYPOINT ["/bin/milmove", "migrate", "-p", "file:///migrate/migrations", "-m", "/migrate/migrations_manifest.txt"]