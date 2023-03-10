FROM golang:1.13.1

WORKDIR /go/src/github.com/IBM/ibm-block-csi-operator/
COPY . .
RUN CGO_ENABLED=1 GOOS=linux go build -mod vendor -o ibm-node-agent -gcflags all=-trimpath=${GOPATH} -asmflags all=-trimpath=${GOPATH} cmd/node/main.go


FROM registry.access.redhat.com/ubi7/ubi:7.6-177

ENV PATH="/driver:${PATH}"
RUN yum install -y iscsi-initiator-utils && yum clean all && rm -rf /var/cache/yum
WORKDIR /driver
COPY --from=0 /go/src/github.com/IBM/ibm-block-csi-operator/ibm-node-agent .
COPY build/node-agent.sh .
RUN chmod -R 755 /driver

ENTRYPOINT ["./node-agent.sh"]
CMD ["ibm-node-agent"]
