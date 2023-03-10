FROM --platform=linux/amd64 zchain_build_base as magic_block_build
ENV SRC_DIR=/0chain
ENV GO111MODULE=on

COPY ./code/go/0chain.net $SRC_DIR/go/0chain.net

RUN cd $SRC_DIR/go/0chain.net && \
    go mod download
WORKDIR $SRC_DIR/go/0chain.net/chaincore/block/magicBlock

RUN cd $GOPATH/pkg/mod/github.com/valyala/gozstd* && \
    chmod -R +w . && \
    make clean libzstd.a

RUN go build -tags bn256 main.go yaml.go

FROM zchain_run_base
ENV APP_DIR=/0chain
WORKDIR $APP_DIR
COPY --from=magic_block_build $APP_DIR/go/0chain.net/chaincore/block/magicBlock/main $APP_DIR/bin/magicBlock