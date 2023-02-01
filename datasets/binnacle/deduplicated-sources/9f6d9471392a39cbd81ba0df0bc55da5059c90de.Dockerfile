FROM golang:1.10.3
WORKDIR /go/src/github.com/ot4i/ace-docker/
COPY cmd/ ./cmd
COPY ./internal/ ./internal
COPY ./vendor/ ./vendor
RUN go build -ldflags "-X \"main.ImageCreated=$(date --iso-8601=seconds)\" -X \"main.ImageRevision=$IMAGE_REVISION\" -X \"main.ImageSource=$IMAGE_SOURCE\"" ./cmd/runaceserver/
RUN go build ./cmd/chkaceready/
RUN go build ./cmd/chkacehealthy/
# Run all unit tests
RUN go test -v ./cmd/runaceserver/
RUN go test -v ./internal/...
RUN go vet ./cmd/... ./internal/...

ARG ACE_INSTALL=ace-11.0.0.3.tar.gz
RUN pwd
WORKDIR /opt/ibm
RUN pwd
COPY ./deps/$ACE_INSTALL .
RUN mkdir ace-11
RUN tar xzf $ACE_INSTALL --absolute-names --exclude ace-11.\*/tools --strip-components 1 --directory /opt/ibm/ace-11
