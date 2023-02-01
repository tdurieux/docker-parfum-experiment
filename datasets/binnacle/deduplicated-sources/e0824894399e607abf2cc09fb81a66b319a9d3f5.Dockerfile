# builder image
FROM golang as builder

RUN GO111MODULE=on go get github.com/onsi/ginkgo/ginkgo@v1.8.0

# final image
# TODO get rid of python dependencies
# * wait-for-update.py
FROM registry.opensource.zalan.do/stups/python:latest

RUN apt-get update && apt-get install -y \
  git \
  pwgen \
  && rm -rf /var/lib/apt/lists/*

ARG KUBE_VERSION
ADD https://storage.googleapis.com/kubernetes-release/release/$KUBE_VERSION/bin/linux/amd64/kubectl /usr/bin/kubectl
RUN chmod +x /usr/bin/kubectl

COPY --from=builder /go/bin/ginkgo /usr/local/bin/ginkgo

# copy CLM
COPY --from=registry.opensource.zalan.do/teapot/cluster-lifecycle-manager:latest /clm /usr/bin/clm

ADD . /workdir

ENV KUBECTL_PATH /usr/bin/kubectl
ENV KUBERNETES_PROVIDER skeleton
ENV KUBERNETES_CONFORMANCE_TEST Y

WORKDIR /workdir/test/e2e

ENTRYPOINT ["./run_e2e.sh"]
