FROM golang:1.11
MAINTAINER Jakub Sztandera <kubuxu@ipfs.io>


RUN apt-get update && apt-get install -y --no-install-recommends \
		netcat-openbsd bash curl \
		sudo \
		&& rm -rf /var/lib/apt/lists/*

ENV GOBIN      $GOPATH/bin
ENV SRC_PATH   /go/src/github.com/ipfs/go-ipfs

RUN curl -f -s https://codecov.io/bash > /usr/bin/codecov && chmod +x /usr/bin/codecov \
	&& go get -u github.com/Kubuxu/gocovmerge && go get -u golang.org/x/tools/cmd/cover
ENV IPFS_SKIP_COVER_BINS 1


RUN useradd user
RUN chown -R user $GOPATH

WORKDIR $SRC_PATH

COPY ./bin $SRC_PATH/bin/
COPY ./mk $SRC_PATH/mk/
RUN chown -R user $GOPATH

USER user
# install gx and gx-go
RUN make -j 4 -f bin/Rules.mk d=bin bin/gx bin/gx-go && cp bin/gx bin/gx-go $GOBIN
USER root
ENV IPFS_GX_USE_GLOBAL 1

COPY package.json $SRC_PATH/
ENV PATH      $SRC_PATH/bin:$PATH

USER user
RUN make -f mk/gx.mk gx-deps
USER root

COPY . $SRC_PATH
RUN chown -R user:user $GOPATH
USER user
# mkdir .git/objects is required for git to detect repo
RUN mkdir .git/objects && make cmd/ipfs/ipfs #populate go cache

CMD ["/bin/bash", "-c", "trap : TERM INT; sleep infinity & wait"]
