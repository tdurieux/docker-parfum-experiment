FROM golang:1.18-alpine as builder
RUN apk add --no-cache make binutils
COPY / /work
WORKDIR /work
RUN make provisioner

FROM alpine:3.15
RUN apk add --no-cache lvm2 e2fsprogs e2fsprogs-extra smartmontools nvme-cli util-linux
COPY --from=builder /work/bin/csi-lvm-provisioner /csi-lvm-provisioner
USER root
ENTRYPOINT ["/csi-lvm-provisioner"]
