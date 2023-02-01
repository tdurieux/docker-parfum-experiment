FROM buildpack-deps:stretch-scm

ENV GO_VERSION_TO_INSTALL %%GO_VERSION%%

# Copied from https://github.com/docker-library/golang/blob/master/Dockerfile-debian.template
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:/usr/local/protoc/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

ADD build.sh /tmp/build.sh
RUN /tmp/build.sh
