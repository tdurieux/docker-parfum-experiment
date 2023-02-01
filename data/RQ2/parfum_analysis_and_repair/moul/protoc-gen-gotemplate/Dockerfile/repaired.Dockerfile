# builder
FROM    golang:1.16-alpine as builder
RUN     apk --no-cache add make git go rsync libc-dev
RUN     go get -u golang.org/x/tools/cmd/goimports
RUN     go get -u github.com/gobuffalo/packr/v2/packr2
COPY    . /go/src/moul.io/protoc-gen-gotemplate
WORKDIR /go/src/moul.io/protoc-gen-gotemplate
RUN     packr2
RUN     go install -a -tags netgo -ldflags '-w -extldflags "-static"' . ./cmd/web-editor
RUN     ls -la /go/bin

# runtime