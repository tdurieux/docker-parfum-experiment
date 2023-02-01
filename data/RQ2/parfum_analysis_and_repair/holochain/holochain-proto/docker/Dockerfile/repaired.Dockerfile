#
# Dockerfile using a multi-stage build
#

# Stage 0 (build) - Build the holochain tools

FROM golang as build
ARG BRANCH=develop
RUN go get -d -v github.com/holochain/holochain-proto
RUN cd $GOPATH/src/github.com/holochain/holochain-proto && git checkout $BRANCH && make

# Stage 1 - Copy holochain tools into a minimal image