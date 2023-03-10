FROM golang:latest as build
WORKDIR $GOPATH/src/github.com/ca-gip/kubi
COPY . $GOPATH/src/github.com/ca-gip/kubi
RUN make build-webhook

FROM scratch
WORKDIR /root/
COPY --from=build /go/src/github.com/ca-gip/kubi/build/kubi-webhook .
EXPOSE 8001
CMD ["./kubi-webhook"]