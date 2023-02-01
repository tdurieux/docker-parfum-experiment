FROM golang:1.12.1 as go-builder

RUN apt-get update && apt-get install -y git

# Install glide
WORKDIR $GOPATH/src/github.com/Masterminds
RUN git clone https://github.com/Masterminds/glide.git
RUN cd glide && git checkout v0.12.3 && make bootstrap-dist && make install

ENV CADENCE_HOME $GOPATH/src/github.com/uber/cadence
RUN git clone https://github.com/uber/cadence.git $CADENCE_HOME
WORKDIR $CADENCE_HOME
RUN cd $CADENCE_HOME && make cadence

FROM phusion/baseimage:0.10.1

COPY --from=go-builder /go/src/github.com/uber/cadence/cadence .
COPY --from=go-builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

ENTRYPOINT ["./cadence"]

