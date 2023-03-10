FROM ghcr.io/aldor007/mort-base 

ENV GOLANG_VERSION 1.16.6
ARG TARGETARCH amd64
ARG TAG 'dev'
ARG COMMIT "master"
ARG DATE "now"

ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-$TARGETARCH.tar.gz

RUN curl -fsSL --insecure "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
  && tar -C /usr/local -xzf golang.tar.gz \
  && rm golang.tar.gz

ENV WORKDIR /workspace
ENV PATH /usr/local/go/bin:$PATH


WORKDIR $WORKDIR
COPY go.mod  ./
COPY go.sum ./
RUN go mod  download

COPY cmd/  $WORKDIR/cmd
COPY .godir ${WORKDIR}/.godir
COPY configuration/ ${WORKDIR}/configuration
COPY etc/ ${WORKDIR}/etc
COPY pkg/ ${WORKDIR}/pkg
COPY scripts/ ${WORKDIR}/scripts
COPY Makefile ${WORKDIR}/Makefile