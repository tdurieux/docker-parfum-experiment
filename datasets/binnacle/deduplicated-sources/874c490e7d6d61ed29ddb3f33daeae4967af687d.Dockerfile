FROM golang:1.10

# Install dep
RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
RUN go get golang.org/x/net/context
RUN mkdir -p /go/pkg/dep

# Prepare function environment
RUN ln -s /kubeless $GOPATH/src/kubeless 
ADD /compile-function.sh /

# Install controller
RUN mkdir -p $GOPATH/src/github.com/kubeless/kubeless/pkg/functions
ADD kubeless/pkg/functions/* $GOPATH/src/github.com/kubeless/kubeless/pkg/functions
ADD kubeless/pkg/function-proxy $GOPATH/src/github.com/kubeless/kubeless/pkg/function-proxy
WORKDIR $GOPATH/src/github.com/kubeless/kubeless/pkg/function-proxy
RUN dep ensure
RUN mkdir -p $GOPATH/src/controller
ADD /Gopkg.toml $GOPATH/src/controller/
WORKDIR $GOPATH/src/controller/
ADD kubeless.tpl.go $GOPATH/src/controller/
RUN dep ensure
RUN chmod -R a+w $GOPATH
RUN chmod -R a+w /go/pkg/dep

USER 1000
