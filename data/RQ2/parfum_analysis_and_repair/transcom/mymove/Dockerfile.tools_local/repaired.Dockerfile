###########
# BUILDER #
###########

FROM milmove/circleci-docker:milmove-app-0a37160d4d9d1e18ea6f1b72f346988fd95c119e as builder

ENV CIRCLECI=true

COPY --chown=circleci:circleci . /home/circleci/project
WORKDIR /home/circleci/project

RUN make clean
RUN rm -f pkg/assets/assets.go && make pkg/assets/assets.go
RUN make server_generate
RUN rm -f bin/generate-test-data && make bin/generate-test-data
RUN rm -f bin/prime-api-client && make bin/prime-api-client

#########
# FINAL #
#########

FROM alpine:3.15.4

# hadolint ignore=DL3017
RUN apk upgrade --no-cache busybox

COPY --from=builder --chown=root:root /home/circleci/project/bin/generate-test-data /bin/generate-test-data
COPY --from=builder --chown=root:root /home/circleci/project/bin/prime-api-client /bin/prime-api-client

# Certs for mTLS authentication
COPY config/tls/devlocal-mtls.cer /bin/config/tls/devlocal-mtls.cer
COPY config/tls/devlocal-mtls.key /bin/config/tls/devlocal-mtls.key

# Specify testdata needed for integration tests
COPY pkg/testdatagen/testdata/test.pdf /bin/pkg/testdatagen/testdata/test.pdf
COPY pkg/testdatagen/testdata/test.jpg /bin/pkg/testdatagen/testdata/test.jpg
COPY pkg/testdatagen/testdata/test.png /bin/pkg/testdatagen/testdata/test.png
COPY pkg/testdatagen/testdata/update_mto_shipment.json /bin/pkg/testdatagen/testdata/update_mto_shipment.json

# Install tools needed in container
RUN apk update
# hadolint ignore=DL3018