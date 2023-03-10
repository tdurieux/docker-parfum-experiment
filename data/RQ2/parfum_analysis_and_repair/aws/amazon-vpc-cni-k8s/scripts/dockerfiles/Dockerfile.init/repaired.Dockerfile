ARG golang_image

FROM $golang_image as builder
WORKDIR /go/src/github.com/aws/amazon-vpc-cni-k8s
ARG TARGETARCH
# Configure build with Go modules
ENV GO111MODULE=on
ENV GOPROXY=direct

COPY Makefile ./
RUN make plugins && make debug-script

COPY . ./

# Build the architecture specific container image:
FROM public.ecr.aws/amazonlinux/amazonlinux:2
RUN yum update -y && \
    yum install -y iproute procps-ng && \
    yum clean all && rm -rf /var/cache/yum

WORKDIR /init

COPY --from=builder \
    /go/src/github.com/aws/amazon-vpc-cni-k8s/loopback \
    /go/src/github.com/aws/amazon-vpc-cni-k8s/portmap \
    /go/src/github.com/aws/amazon-vpc-cni-k8s/bandwidth \
    /go/src/github.com/aws/amazon-vpc-cni-k8s/aws-cni-support.sh \
    /go/src/github.com/aws/amazon-vpc-cni-k8s/scripts/init.sh /init/

ENTRYPOINT ["/init/init.sh"]
