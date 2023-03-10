FROM golang:1.17

RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.35.2

RUN wget -nv https://github.com/mikefarah/yq/releases/download/3.4.1/yq_linux_amd64 -O /usr/bin/yq && chmod a+x /usr/bin/yq
RUN go get -u github.com/client9/misspell/cmd/misspell