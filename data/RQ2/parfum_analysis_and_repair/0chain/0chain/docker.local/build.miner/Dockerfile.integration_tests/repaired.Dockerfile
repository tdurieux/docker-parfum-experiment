# Compile the miner in an un-tagged image so the final, tagged image can be smaller:
FROM zchain_build_base as miner_build
ENV SRC_DIR=/0chain
ENV GO111MODULE=on

# Download the dependencies:
# Will be cached if we don't change mod/sum files
COPY ./code/go/0chain.net/go.mod $SRC_DIR/go/0chain.net/
COPY ./code/go/0chain.net/go.sum $SRC_DIR/go/0chain.net/

RUN cd $SRC_DIR/go/0chain.net && \
    go mod download
WORKDIR $SRC_DIR/go/0chain.net/miner/miner

# Build libzstd:
# FIXME: Change this after https://github.com/valyala/gozstd/issues/6 is fixed.
# FIXME: Also, is there a way we can move this to zchain_build_base?
RUN cd $GOPATH/pkg/mod/github.com/valyala/gozstd* && \
   chmod -R +w . && \
   make clean libzstd.a

COPY ./code/go/0chain.net $SRC_DIR/go/0chain.net

# Build it:
ARG GIT_COMMIT
ENV GIT_COMMIT=$GIT_COMMIT
RUN go build -v -tags "bn256 development integration_tests" -ldflags "-X 0chain.net/core/build.BuildTag=$GIT_COMMIT"


# Copy the build artifact into a minimal runtime image: