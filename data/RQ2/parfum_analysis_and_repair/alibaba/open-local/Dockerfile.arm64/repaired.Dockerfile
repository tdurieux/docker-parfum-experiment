FROM golang:1.15.6@sha256:a3c6ad248e08e28868dac893ed96fec00e5b110d005238fdae177772486947b0 AS builder

WORKDIR /go/src/github.com/alibaba/open-local
COPY . .
RUN make build && chmod +x bin/open-local

FROM centos:7@sha256:864a7acea4a5e8fa7a4d83720fbcbadbe38b183f46f3600e04a3f8c1d961ed87 AS centos
RUN yum install -y file xfsprogs e4fsprogs lvm2 util-linux && rm -rf /var/cache/yum
COPY --from=builder /go/src/github.com/alibaba/open-local/bin/open-local /bin/open-local
ENTRYPOINT ["open-local"]