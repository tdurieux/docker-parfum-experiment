FROM deepfabric/build as builder

COPY . /root/go/src/github.com/deepfabric/elasticell
WORKDIR /root/go/src/github.com/deepfabric/elasticell
RUN make release

FROM deepfabric/centos

COPY --from=builder /root/go/src/github.com/deepfabric/elasticell/dist/cell /usr/local/bin/cell
COPY --from=builder /root/go/src/github.com/deepfabric/elasticell/dist/pd /usr/local/bin/pd
COPY --from=builder /root/go/src/github.com/deepfabric/elasticell/dist/proxy /usr/local/bin/proxy

RUN mkdir -p /apps/deepfabric/cfg \
    && mkdir -p /apps/deepfabric/log \
    && mkdir -p /apps/deepfabric/pd1/data \
    && mkdir -p /apps/deepfabric/pd2/data \
    && mkdir -p /apps/deepfabric/pd3/data \
    && mkdir -p /apps/deepfabric/cell1/data \
    && mkdir -p /apps/deepfabric/cell2/data \
    && mkdir -p /apps/deepfabric/cell3/data

ENTRYPOINT ["/usr/local/bin/cell"]

COPY ./quickstart-cfgs /apps/deepfabric/cfg
COPY ./entrypoint-quickstart.sh /apps/deepfabric

RUN chmod +x /apps/deepfabric/entrypoint-quickstart.sh

WORKDIR /apps/deepfabric
ENTRYPOINT ["/apps/deepfabric/entrypoint-quickstart.sh"]