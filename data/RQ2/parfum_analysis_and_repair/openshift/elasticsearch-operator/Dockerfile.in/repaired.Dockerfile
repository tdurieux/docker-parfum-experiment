#@follow_tag(registry-proxy.engineering.redhat.com/rh-osbs/openshift-golang-builder:rhel_8_golang_1.17)
FROM registry-proxy.engineering.redhat.com/rh-osbs/openshift-golang-builder:v1.17.5-202202101345.el8.gb1a57e0 AS builder


ENV BUILD_VERSION=${CI_CONTAINER_VERSION}
ENV OS_GIT_MAJOR=${CI_X_VERSION}
ENV OS_GIT_MINOR=${CI_Y_VERSION}
ENV OS_GIT_PATCH=${CI_Z_VERSION}
ENV SOURCE_GIT_COMMIT=${CI_ELASTICSEARCH_OPERATOR_UPSTREAM_COMMIT}
ENV SOURCE_GIT_URL=${CI_ELASTICSEARCH_OPERATOR_UPSTREAM_URL}

## EXCLUDE BEGIN ##
ENV REMOTE_SOURCE=${REMOTE_SOURCE}/app
## EXCLUDE END ##

WORKDIR /go/src/github.com/openshift/elasticsearch-operator

COPY ${REMOTE_SOURCE}/apis apis
COPY ${REMOTE_SOURCE}/controllers controllers
COPY ${REMOTE_SOURCE}/files files
COPY ${REMOTE_SOURCE}/internal internal
COPY ${REMOTE_SOURCE}/bundle bundle
COPY ${REMOTE_SOURCE}/version version
COPY ${REMOTE_SOURCE}/.bingo ./.bingo
ADD ${REMOTE_SOURCE}/Makefile ${REMOTE_SOURCE}/main.go ${REMOTE_SOURCE}/go.mod ${REMOTE_SOURCE}/go.sum ./

RUN make build

#@follow_tag(registry.redhat.io/ubi8:latest)