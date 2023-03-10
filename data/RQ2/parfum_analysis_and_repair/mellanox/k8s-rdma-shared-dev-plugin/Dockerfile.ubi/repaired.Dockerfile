ARG BASE_IMAGE=registry.access.redhat.com/ubi8/ubi-minimal:8.5

FROM golang:alpine as builder

ADD . /usr/src/k8s-rdma-shared-dp

ENV HTTP_PROXY $http_proxy
ENV HTTPS_PROXY $https_proxy

RUN apk add --no-cache --update --virtual build-dependencies build-base linux-headers git && \
    cd /usr/src/k8s-rdma-shared-dp && \
    make clean && \
    make build

FROM ${BASE_IMAGE}
RUN microdnf install kmod hwdata
COPY --from=builder /usr/src/k8s-rdma-shared-dp/build/k8s-rdma-shared-dp /bin/

LABEL io.k8s.display-name="RDMA Shared Device Plugin"

CMD ["/bin/k8s-rdma-shared-dp"]
