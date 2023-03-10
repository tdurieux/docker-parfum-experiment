###########
# BUILDER #
###########

FROM milmove/circleci-docker:milmove-app-0a37160d4d9d1e18ea6f1b72f346988fd95c119e as builder

# Prepare public DOD certificates.
# hadolint ignore=DL3002
USER root
COPY config/tls/dod-wcf-root-ca-1.pem /usr/local/share/ca-certificates/dod-wcf-root-ca-1.pem.crt
COPY config/tls/dod-wcf-intermediate-ca-1.pem /usr/local/share/ca-certificates/dod-wcf-intermediate-ca-1.pem.crt
COPY config/tls/Certificates_PKCS7_v5.6_DoD.der.p7b /tmp/all-public-dod-certs.der.p7b
RUN openssl pkcs7 -print_certs -inform der -in /tmp/all-public-dod-certs.der.p7b -out /usr/local/share/ca-certificates/all-public-dod-certs.crt
RUN update-ca-certificates

#########
# FINAL #
#########
# hadolint ignore=DL3007
FROM gcr.io/distroless/static:latest

# Copy DOD certs from the builder.