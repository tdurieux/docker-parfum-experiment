FROM quay.io/stackrox-io/apollo-ci:scanner-test-0.3.42

COPY . /go/src/github.com/stackrox/scanner
WORKDIR /go/src/github.com/stackrox/scanner

RUN ./.openshift-ci/build/generate-genesis-dump.sh