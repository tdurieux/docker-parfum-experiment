FROM golang:latest
MAINTAINER vmarmol@google.com

RUN apt-get install --no-install-recommends -y git dmsetup && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/google/cadvisor.git /go/src/github.com/google/cadvisor
RUN cd /go/src/github.com/google/cadvisor && make

ENTRYPOINT ["/go/src/github.com/google/cadvisor/cadvisor"]

