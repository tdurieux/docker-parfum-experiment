FROM will_be_replaced_by_openshift_ci

ENV SRC_ROOT_DIR=/go/src/github.com/stackrox/collector
WORKDIR $SRC_ROOT_DIR

RUN ./.openshift-ci/build/build-collector.sh