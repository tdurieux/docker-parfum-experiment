FROM carml/base:amd64-gpu-latest
MAINTAINER Abdul Dakkak <dakkak@illinois.edu>

LABEL org.carml.version=0.3.9

WORKDIR $GOPATH/src/github.com/rai-project/mlmodelscope
RUN git clone --depth=1 --branch=master https://github.com/rai-project/mlmodelscope.git . && \
    dep ensure -v -vendor-only && \
    go get golang.org/x/crypto/acme/autocert && \
    go build && \
    mv mlmodelscope /usr/bin && \
    rm -fr $GOPATH

ENV PORT 80
ENTRYPOINT ["mlmodelscope", "web", "--debug", "--verbose"]
EXPOSE 80