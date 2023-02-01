FROM golang:1.16 as stage-build
LABEL stage=stage-build
WORKDIR /build/ko
ARG GOPROXY
ARG GOARCH
ARG XPACK

ENV GO111MODULE=on \
    GOPROXY=$GOPROXY \
    CGO_ENABLED=1 \
    GOOS=linux \
    GOARCH=$GOARCH

RUN apt-get update && apt-get install unzip

COPY go.mod go.sum ./
RUN go mod download

RUN cd /tmp \
    && wget https://kubeoperator.oss-cn-beijing.aliyuncs.com/go-bindata/v3.1.3/go-bindata.zip \
    && unzip go-bindata.zip  \
    && cd go-bindata-3.1.3 \
    && go build \
    && cd go-bindata \
    && go build \
    && cp go-bindata /go/bin

RUN export PATH=$PATH:$GOPATH/bin

COPY . .
RUN make build_server_linux GOARCH=$GOARCH

RUN if [ "$XPACK" = "yes" ] ; then  cd xpack && sed -i 's/ ..\/KubeOperator/ \..\/..\/ko/g' go.mod && make build_linux GOARCH=$GOARCH && cp -r dist/* ../dist/  ; fi

FROM ubuntu:20.04
ARG GOARCH

RUN apt-get update && \
    apt -y upgrade && \
    apt-get -y install wget curl git iputils-ping
RUN setcap cap_net_raw=+ep /bin/ping

WORKDIR /usr/local/bin

RUN wget https://fit2cloud-support.oss-cn-beijing.aliyuncs.com/xpack-license/validator_linux_$GOARCH && chmod +x validator_linux_$GOARCH
RUN wget https://kubeoperator.oss-cn-beijing.aliyuncs.com/ko-encrypt/encrypt_linux_$GOARCH && chmod +x encrypt_linux_$GOARCH

WORKDIR /tmp

RUN wget https://kubeoperator.oss-cn-beijing.aliyuncs.com/polaris/4.1.0/polaris.tar.gz \
    && tar zxvf ./polaris.tar.gz \
    && mv ./polaris-4.1.0/checks/ /checks

RUN wget https://dl.k8s.io/v1.18.6/kubernetes-client-linux-$GOARCH.tar.gz && tar -zvxf kubernetes-client-linux-$GOARCH.tar.gz \
    && cp ./kubernetes/client/bin/* /usr/local/bin \
    && chmod +x /usr/local/bin/kubectl

RUN wget https://kubeoperator.oss-cn-beijing.aliyuncs.com/velero/v1.7.1/velero-v1.7.1-linux-$GOARCH.tar.gz && tar -zxvf velero-v1.7.1-linux-$GOARCH.tar.gz \
    && cp ./velero-v1.7.1-linux-$GOARCH/velero /usr/local/bin \
    && chmod +x /usr/local/bin/velero

WORKDIR /

COPY --from=stage-build /build/ko/dist/etc /etc/
COPY --from=stage-build /usr/local/go/lib/time/zoneinfo.zip /opt/zoneinfo.zip
ENV ZONEINFO /opt/zoneinfo.zip

COPY --from=stage-build /build/ko/dist/etc /etc/
COPY --from=stage-build /build/ko/dist/usr /usr/

EXPOSE 8080

CMD ["ko-server"]
