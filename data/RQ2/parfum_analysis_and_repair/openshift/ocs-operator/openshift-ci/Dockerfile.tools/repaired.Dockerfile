FROM fedora:34 as build-tools
ENV GOPATH /go
ENV GOBIN /go/bin
ENV GOCACHE /go/.cache
ARG GO_PACKAGE_PATH=github.com/red-hat-storage/ocs-operator

# rpms required for building and running test suites
RUN dnf -y install \
    make \
    gcc \
    wget \
    git \
    tar \
    findutils \
    python3 \
    go \
    && dnf clean all

ENV PATH=$GOPATH:$GOBIN:$PATH
ENV GO111MODULE=on

# get required golang tools and OC client
RUN go get github.com/onsi/ginkgo/ginkgo && \
    go get github.com/onsi/gomega/... && \
    go get -u golang.org/x/lint/golint && \
    export latest_oc_client_version=$( curl -f https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/ 2>/dev/null | grep -o \"openshift-client-linux-4.*tar.gz\" | tr -d \") && \
    curl -f -JL https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/${latest_oc_client_version} -o oc.tar.gz && \
    tar -xzvf oc.tar.gz && \
    mv oc /usr/bin/oc && rm oc.tar.gz

RUN export TMP_BIN=$(mktemp -d) && \
    mv $GOBIN/* $TMP_BIN/ && \
    rm -rf ${GOPATH} ${GOCACHE} && \
    mkdir -p ${GOPATH}/src/${GO_PACKAGE_PATH}/ && \
    mkdir -p ${GOBIN} && \
    chmod -R 775 ${GOPATH} && \
    mv $TMP_BIN/* ${GOBIN} && \
    rm -rf $TMP_BIN

# openshift ci runs with a randomized uid. We need the ability
# to create a /etc/passwd entry for this random user in order
# to execute the ocs-ci python testsuite successfully
RUN chmod g+rw /etc/passwd

WORKDIR ${GOPATH}/src/${GO_PACKAGE_PATH}

ENTRYPOINT [ "/bin/bash" ]
