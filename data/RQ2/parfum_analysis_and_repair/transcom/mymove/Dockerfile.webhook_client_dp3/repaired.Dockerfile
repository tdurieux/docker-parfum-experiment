###########
# BUILDER #
###########

FROM milmove/circleci-docker:milmove-app-0a37160d4d9d1e18ea6f1b72f346988fd95c119e as builder

# Prepare public DOD certificates.
# hadolint ignore=DL3002
USER root

# Demo Environment Certs
COPY config/tls/api.demo.dp3.us.p7b /tmp/api.demo.dp3.us.p7b
RUN openssl pkcs7 -print_certs -inform der -in /tmp/api.demo.dp3.us.p7b -out /usr/local/share/ca-certificates/api.demo.dp3.us.crt
# Loadtesting Environment Certs
COPY config/tls/api.loadtest.dp3.us.chain.der.p7b /tmp/api.loadtest.dp3.us.chain.der.p7b
RUN openssl pkcs7 -print_certs -inform der -in /tmp/api.loadtest.dp3.us.chain.der.p7b -out /usr/local/share/ca-certificates/api.loadtest.dp3.us.chain.der.crt
# Exp Environment Certs
COPY config/tls/api.exp.dp3.us.chain.der.p7b /tmp/api.exp.dp3.us.chain.der.p7b
RUN openssl pkcs7 -print_certs -inform der -in /tmp/api.exp.dp3.us.chain.der.p7b -out /usr/local/share/ca-certificates/api.exp.dp3.us.chain.der.crt


RUN update-ca-certificates

#########
# FINAL #
#########
# hadolint ignore=DL3007
FROM gcr.io/distroless/static:latest

# Copy DOD certs from the builder.
COPY --from=builder --chown=root:root /etc/ssl/certs /etc/ssl/certs

#AWS GovCloud RDS cert