FROM quay.io/bitriseio/bitrise-base

WORKDIR /bitrise/go/src/github.com/bitrise-io/bitrise-workflow-editor

RUN go get github.com/codegangsta/gin \
    && go get github.com/golang/dep/cmd/dep