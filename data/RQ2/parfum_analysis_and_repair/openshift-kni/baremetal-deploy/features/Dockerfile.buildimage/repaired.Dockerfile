FROM fedora:31

ENV GOPATH /go
ENV GOBIN /go/bin
ENV GOCACHE /go/.cache
ENV GOVERSION 1.13.5
ENV PATH=$PATH:/root/.gimme/versions/go"$GOVERSION".linux.amd64/bin:$GOBIN

# rpms required for building and running test suites
RUN dnf -y install \
    gcc \
    git \
    make \
    gettext \
    which \
    findutils \
    python2 \
    && dnf clean all

RUN mkdir ~/bin && \
    # install Go using gimme
    curl -f -sL -o /usr/local/bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme && \
    chmod +x /usr/local/bin/gimme && \
    eval "$(gimme $GOVERSION)" && \
    cat $GIMME_ENV >> $HOME/.bashrc && \
    # get required golang tools and OC client
    go get github.com/onsi/ginkgo/ginkgo && \
    go get github.com/onsi/gomega/... && \
    go get -u golang.org/x/lint/golint && \
    export latest_oc_client_version=$( curl -f https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/ 2>/dev/null | grep -o \"openshift-client-linux-4.*tar.gz\" | tr -d \") && \
    curl -f -JL https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/${latest_oc_client_version} -o oc.tar.gz && \
    tar -xzvf oc.tar.gz && \
    mv oc /usr/local/bin/oc && \
    rm -f oc.tar.gz

RUN export TMP_BIN=$(mktemp -d) && \
    mv $GOBIN/* $TMP_BIN/ && \
    rm -rf ${GOPATH} ${GOCACHE} && \
    mkdir -p ${GOBIN} && \
    chmod -R 775 ${GOPATH} && \
    mv $TMP_BIN/* ${GOBIN} && \
    rm -rf $TMP_BIN

WORKDIR /src/

ENTRYPOINT [ "/bin/bash" ]