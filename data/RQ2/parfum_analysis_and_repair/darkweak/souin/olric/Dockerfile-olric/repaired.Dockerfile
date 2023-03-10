FROM docker.io/olricio/olricd:latest as olric

ENV OLRICD_CONFIG /etc/olricd.yaml
ENV CGO_ENABLED 1

# WORKDIR /go

# RUN go get -u github.com/buraksezer/olric
# 
# WORKDIR /go/src/github.com/buraksezer/olric
# 
# RUN go build -v -o /go/bin/olricd /go/src/github.com/buraksezer/olric/cmd/olricd/main.go
COPY ./olric.yml /etc/olricd.yaml

CMD ["/go/bin/olricd", "-c", "/etc/olricd.yaml"]