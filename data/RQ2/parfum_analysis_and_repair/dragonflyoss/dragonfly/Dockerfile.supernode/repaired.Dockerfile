FROM golang:1.13.15-alpine as builder

WORKDIR /go/src/github.com/dragonflyoss/Dragonfly
RUN apk --no-cache add bash make gcc libc-dev git

COPY . /go/src/github.com/dragonflyoss/Dragonfly

# go build supernode.
# write the resulting executable to the dir /opt/dragonfly/df-supernode.
ARG GOPROXY
RUN make build-supernode && make install-supernode
RUN make build-client && make install-client

FROM nginx:1.19.2-alpine

RUN apk --no-cache add ca-certificates bash

COPY --from=builder /go/src/github.com/dragonflyoss/Dragonfly/hack/start-supernode.sh /root/start.sh
COPY --from=builder /go/src/github.com/dragonflyoss/Dragonfly/hack/supernode-nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /opt/dragonfly/df-supernode/supernode /opt/dragonfly/df-supernode/supernode
COPY --from=builder /opt/dragonfly/df-client /opt/dragonfly/df-client
RUN ln -s /opt/dragonfly/df-client/dfget /usr/local/bin/dfget


# supernode will listen 8001,8002 in default.
EXPOSE 8001 8002

ENTRYPOINT ["/root/start.sh"]