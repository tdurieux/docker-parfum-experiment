FROM registry.ci.openshift.org/openshift/release:golang-1.18

ENV OPERATOR_SDK_VERSION=v1.14.0

# install operator-sdk (from git with no history and only the tag)
RUN mkdir -p $GOPATH/src/github.com/operator-framework \
    && cd $GOPATH/src/github.com/operator-framework \
    && git clone --depth 1 -b $OPERATOR_SDK_VERSION https://github.com/operator-framework/operator-sdk \
    && cd operator-sdk \
    && go mod vendor \
    && go mod tidy \
    && make install \
    && chmod -R 0777 $GOPATH \
    && rm -rf $GOPATH/.cache