FROM golang:1.15 as go_build

RUN apt-get update && apt-get install --no-install-recommends -y \
  curl \
  git \
  lame \
  libmp3lame-dev && rm -rf /var/lib/apt/lists/*;

RUN curl -f -L \
  "https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-linux-x86_64-1.8.0.tar.gz" | \
  tar -C /usr/local -xz
ENV LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib

# go deps for tf
RUN mkdir -p ${GOPATH}/src/github.com/tensorflow/ && \
  cd ${GOPATH}/src/github.com/tensorflow/ && \
  git clone https://github.com/tensorflow/tensorflow.git

RUN cd ${GOPATH}/src/github.com/tensorflow/tensorflow && git checkout v1.8.0

RUN go get github.com/Shopify/sarama
RUN go get github.com/viert/lame



COPY evtstreams/sdr2evtstreams/main.go /
COPY evtstreams/sdr2evtstreams/audiolib/audiolib.go /go/src/github.com/open-horizon/examples/edge/evtstreams/sdr2evtstreams/audiolib/audiolib.go
COPY services/sdr/rtlsdrclientlib/clientlib.go /go/src/github.com/open-horizon/examples/edge/services/sdr/rtlsdrclientlib/clientlib.go
RUN go build -o /bin/data_broker /main.go

FROM ubuntu:18.04
RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  tar \
  ncdu \
  curl \
  lame && rm -rf /var/lib/apt/lists/*;

RUN curl -f -L \
  "https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-linux-x86_64-1.8.0.tar.gz" | \
  tar -C /usr/local -xz
ENV LD_LIBRARY_PATH=/usr/local/lib

COPY evtstreams/sdr2evtstreams/model.pb /model.pb

COPY --from=go_build /bin/data_broker /bin/data_broker

CMD ["data_broker"]
