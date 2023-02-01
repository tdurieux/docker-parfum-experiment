# Build gqlc in a stock Go builder container
FROM qlcchain/go-qlc-builder:latest as builder

ARG BUILD_ACT=build

COPY . /qlcchain/go-qlc
RUN cd /qlcchain/go-qlc && make clean ${BUILD_ACT}

# Pull gqlc into a second stage deploy alpine container