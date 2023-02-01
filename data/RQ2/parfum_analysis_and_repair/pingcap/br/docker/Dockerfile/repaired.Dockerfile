# For loading data to TiDB
FROM golang:1.16.4-buster as go-ycsb-builder
WORKDIR /go/src/github.com/pingcap/
RUN git clone https://github.com/pingcap/go-ycsb.git && \
    cd go-ycsb && \
    make

# For operating minio S3 compatible storage