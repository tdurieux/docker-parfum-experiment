FROM golang:1.12.6-stretch as builder

RUN mkdir -p /tmp/go && cd /tmp/go && git clone https://github.com/go-delve/delve/
RUN cd /tmp/go/delve/ && git checkout v1.2.0
RUN cd /tmp/go/delve/cmd/dlv && go install


FROM golang:1.12.6-stretch

COPY --from=builder $GOPATH/bin/dlv $GOPATH/bin/

ENV DEBUGGER=dlv
COPY plank /
ENTRYPOINT ["/plank"]