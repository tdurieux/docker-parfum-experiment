FROM golang:1.18-alpine as builder
RUN apk add --no-cache make binutils git
COPY / /work
WORKDIR /work
RUN make lvmplugin

FROM alpine:3.15
LABEL maintainers="Metal Authors"
LABEL description="LVM Driver"

RUN apk add --no-cache lvm2 lvm2-extra e2fsprogs e2fsprogs-extra smartmontools nvme-cli util-linux device-mapper
COPY --from=builder /work/bin/lvmplugin /lvmplugin
USER root
ENTRYPOINT ["/lvmplugin"]
