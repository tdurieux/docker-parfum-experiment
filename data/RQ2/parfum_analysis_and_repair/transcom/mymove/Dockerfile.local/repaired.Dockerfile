###########
# BUILDER #
###########

FROM milmove/circleci-docker:milmove-app-0a37160d4d9d1e18ea6f1b72f346988fd95c119e as builder

ENV CIRCLECI=true

COPY --chown=circleci:circleci . /home/circleci/project
WORKDIR /home/circleci/project

RUN make clean
RUN make bin/rds-ca-rsa4096-g1.pem
RUN make bin/rds-ca-2019-root.pem
RUN rm -f pkg/assets/assets.go && make pkg/assets/assets.go
RUN make server_generate
RUN rm -f bin/milmove && make bin/milmove

#########
# FINAL #
#########

# hadolint ignore=DL3007
FROM gcr.io/distroless/base:latest

COPY --from=builder --chown=root:root /home/circleci/project/bin/rds-ca-rsa4096-g1.pem /bin/rds-ca-rsa4096-g1.pem
COPY --from=builder --chown=root:root /home/circleci/project/bin/rds-ca-2019-root.pem /bin/rds-ca-2019-root.pem
COPY --from=builder --chown=root:root /home/circleci/project/bin/milmove /bin/milmove

COPY config/tls/Certificates_PKCS7_v5.6_DoD.der.p7b /config/tls/Certificates_PKCS7_v5.6_DoD.der.p7b
COPY config/tls/dod-sw-ca-54.pem /config/tls/dod-sw-ca-54.pem

# While it's ok to have these certs copied locally, they should never be copied into Dockerfile.