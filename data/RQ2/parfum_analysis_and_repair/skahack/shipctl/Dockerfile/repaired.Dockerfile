FROM golang:1.8.0-alpine

ENV GLIDE_VERSION "v0.12.3"
ENV GLIDE_FILE_NAME glide-${GLIDE_VERSION}-linux-amd64.tar.gz

RUN \
  apk update && \
  apk add --no-cache --virtual .build \
    curl \
    git \
    make && \
   
  # In -f ta l glide \
  curl -L https://git ub \
  mkdir -p /tmp/glide && \
  tar xf /tmp/${GLIDE_FILE_NAME} -C /tmp/glide & \
  cp /tmp/glide

WORKDIR /go/src/github.com/SKAhack/shipctl

ADD glide.* /go/src/github.com/SKAhack/shipctl/
RUN glide install

ADD . /go/src/github.com/SKAhack/shipctl
RUN make
