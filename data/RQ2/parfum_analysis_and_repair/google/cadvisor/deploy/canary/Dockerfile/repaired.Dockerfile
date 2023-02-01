FROM golang:1.18
MAINTAINER dashpole@google.com

RUN apt-get update && apt-get install --no-install-recommends -y git dmsetup && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/google/cadvisor.git /go/src/github.com/google/cadvisor
RUN cd /go/src/github.com/google/cadvisor && make

ENTRYPOINT ["/go/src/github.com/google/cadvisor/cadvisor"]

