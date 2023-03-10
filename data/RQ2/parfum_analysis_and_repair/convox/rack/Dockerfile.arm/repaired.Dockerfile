## package #####################################################################

FROM golang:1.16 AS package

RUN apt-get update && apt-get -y --no-install-recommends install upx-ucl && rm -rf /var/lib/apt/lists/*;

RUN go get -u github.com/gobuffalo/packr/packr

WORKDIR /go/src/github.com/convox/rack

COPY . /go/src/github.com/convox/rack
RUN make package build compress

## production ##################################################################

FROM ubuntu:18.04

ARG DOCKER_ARCH=aarch64
ARG KUBECTL_ARCH=arm64

RUN apt-get -qq update && apt-get -qq --no-install-recommends -y install curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -s https://download.docker.com/linux/static/stable/${DOCKER_ARCH}/docker-18.03.1-ce.tgz | \
    tar -C /usr/bin --strip-components 1 -xz

RUN curl -f -Ls https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/${KUBECTL_ARCH}/kubectl -o /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl

ENV DEVELOPMENT=false
ENV GOPATH=/go
ENV PATH=$PATH:/go/bin

WORKDIR /rack

COPY --from=package /go/bin/atom /go/bin/
COPY --from=package /go/bin/build /go/bin/
COPY --from=package /go/bin/convox-env /go/bin/
COPY --from=package /go/bin/monitor /go/bin/
COPY --from=package /go/bin/rack /go/bin/
COPY --from=package /go/bin/router /go/bin/

# aws templates
COPY --from=package /go/src/github.com/convox/rack/provider/aws/formation/ provider/aws/formation/
COPY --from=package /go/src/github.com/convox/rack/provider/aws/templates/ provider/aws/templates/

CMD ["/go/bin/rack"]
