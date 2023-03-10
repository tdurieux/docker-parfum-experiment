FROM cloudfoundry/cflinuxfs2

ENV GOPATH /go
ENV GOBIN /go/bin
RUN /bin/bash -c '\
  mkdir -p /usr/local/ && \
  URL=https://storage.googleapis.com/golang/go1.12.4.linux-amd64.tar.gz && \
  curl -s -L --retry 15 --retry-delay 2 $URL -o /tmp/go.tar.gz && \
  tar xzf /tmp/go.tar.gz -C /usr/local/ && \
  rm /tmp/go.tar.gz'

ENV PATH $GOBIN:/usr/local/go/bin:$PATH
RUN go get github.com/onsi/ginkgo/ginkgo && go get github.com/onsi/gomega

ADD . /go/src/code.cloudfoundry.org/buildpackapplifecycle/

WORKDIR /go/src/code.cloudfoundry.org/buildpackapplifecycle/
RUN GO111MODULE=off go get -t ./...

CMD ginkgo -r -p