FROM golang:1.8

RUN apt-get update && apt-get install --no-install-recommends -y autoconf && rm -rf /var/lib/apt/lists/*;

ENV GOPATH /gopath
ENV CODIS  ${GOPATH}/src/github.com/CodisLabs/codis
ENV PATH   ${GOPATH}/bin:${PATH}:${CODIS}/bin
COPY . ${CODIS}

RUN make -C ${CODIS} distclean
RUN make -C ${CODIS} build-all

WORKDIR /codis
