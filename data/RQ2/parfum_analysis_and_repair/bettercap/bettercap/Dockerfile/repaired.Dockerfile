# build stage
FROM golang:alpine AS build-env

ENV SRC_DIR $GOPATH/src/github.com/bettercap/bettercap

RUN apk add --no-cache ca-certificates
RUN apk add --no-cache bash iptables wireless-tools build-base libpcap-dev libusb-dev linux-headers libnetfilter_queue-dev git

WORKDIR $SRC_DIR
ADD . $SRC_DIR
RUN make

# get caplets
RUN mkdir -p /usr/local/share/bettercap
RUN git clone https://github.com/bettercap/caplets /usr/local/share/bettercap/caplets

# final stage