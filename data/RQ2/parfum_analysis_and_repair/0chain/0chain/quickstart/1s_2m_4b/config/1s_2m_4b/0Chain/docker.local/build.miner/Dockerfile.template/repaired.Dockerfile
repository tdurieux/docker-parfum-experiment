# Compile the miner in an un-tagged image so the final, tagged image can be smaller:
FROM zchain_build_base as miner_build
ENV SRC_DIR=/0chain
ENV GO111MODULE=on

# Download the dependencies:
# Will be cached if we don't change mod/sum files
COPY ./code/go/0chain.net/core/go.mod          ./code/go/0chain.net/core/go.sum          $SRC_DIR/go/0chain.net/core/
COPY ./code/go/0chain.net/chaincore/go.mod     ./code/go/0chain.net/chaincore/go.sum     $SRC_DIR/go/0chain.net/chaincore/
COPY ./code/go/0chain.net/smartcontract/go.mod ./code/go/0chain.net/smartcontract/go.sum $SRC_DIR/go/0chain.net/smartcontract/
COPY ./code/go/0chain.net/conductor/go.mod     ./code/go/0chain.net/conductor/go.sum     $SRC_DIR/go/0chain.net/conductor/
COPY ./code/go/0chain.net/miner/go.mod         ./code/go/0chain.net/miner/go.sum         $SRC_DIR/go/0chain.net/miner/
COPY ./code/go/0chain.net/sharder/go.mod       ./code/go/0chain.net/sharder/go.sum         $SRC_DIR/go/0chain.net/sharder/
COPY ./code/go/0chain.net/miner/miner/go.mod   ./code/go/0chain.net/miner/miner/go.sum   $SRC_DIR/go/0chain.net/miner/miner/
WORKDIR $SRC_DIR/go/0chain.net/miner/miner
RUN go mod download

# Build libzstd:
# FIXME: Change this after https://github.com/valyala/gozstd/issues/6 is fixed.
# FIXME: Also, is there a way we can move this to zchain_build_base?
RUN cd $GOPATH/pkg/mod/github.com/valyala/gozstd* && \
    chmod -R +w . && \
    make clean libzstd.a

# Add the source code:
COPY ./code/go/0chain.net $SRC_DIR/go/0chain.net

# Build it:
ARG GIT_COMMIT
ENV GIT_COMMIT=$GIT_COMMIT
RUN if [ "$DEV" = "yes" ] ;\
    then echo "Artifacts will be copied from local machine";\
    else go build -v -tags "bn256 development" -gcflags "all=-N -l" -ldflags "-X 0chain.net/core/build.BuildTag=$GIT_COMMIT" ;\
fi

# Copy the build artifact into a minimal runtime image: