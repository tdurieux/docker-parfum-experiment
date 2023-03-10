FROM arm64v8/golang:alpine as builder

ADD . /usr/src/sriov-network-device-plugin

ENV HTTP_PROXY $http_proxy
ENV HTTPS_PROXY $https_proxy
RUN apk add --no-cache --update --virtual build-dependencies build-base linux-headers make && \
    cd /usr/src/sriov-network-device-plugin && \
    make clean && \
    make build

FROM arm64v8/alpine
RUN apk add --no-cache hwdata-pci
COPY --from=builder /usr/src/sriov-network-device-plugin/build/sriovdp /usr/bin/
WORKDIR /

LABEL io.k8s.display-name="SRIOV Network Device Plugin PPC64LE"

ADD ./images/entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
