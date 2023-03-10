# AWE worker with CWL runner

# docker build -t mgrast/awe-submitter -f Dockerfile_submitter .


FROM golang:1.12-alpine3.10

# git needed for GIT_COMMIT_HASH
RUN apk update && apk add --no-cache git

ENV AWE=/go/src/github.com/MG-RAST/AWE
WORKDIR /go/bin

COPY . /go/src/github.com/MG-RAST/AWE

# backwards compatible pathing with old dockerfile
RUN ln -s /go /gopath

# compile AWE
RUN mkdir -p ${AWE} && \
  cd ${AWE} && \
  go get -d ./awe-submitter/ && \
  ./compile-submitter.sh

# install cwl-runner with node.js
RUN apk update ; apk add --no-cache \
  gcc \
  git \
  libxml2-dev \
  libxslt-dev \
  musl-dev \
  nodejs \
  python3-dev \
  py3-libxml2 \
  py3-pip \
  py3-psutil

RUN pip3 install --no-cache-dir --upgrade pip; pip3 install --no-cache-dir lxml; pip3 install --no-cache-dir cwl-runner
