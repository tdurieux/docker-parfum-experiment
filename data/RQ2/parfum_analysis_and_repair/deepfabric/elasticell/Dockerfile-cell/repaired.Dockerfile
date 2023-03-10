FROM deepfabric/build as builder

COPY . /root/go/src/github.com/deepfabric/elasticell
WORKDIR /root/go/src/github.com/deepfabric/elasticell

RUN make cell

FROM deepfabric/centos
COPY --from=builder /root/go/src/github.com/deepfabric/elasticell/dist/cell /usr/local/bin/cell

ENTRYPOINT ["/usr/local/bin/cell"]