FROM golang:latest as build
WORKDIR $GOPATH/src/github.com/ca-gip/kubi
COPY . $GOPATH/src/github.com/ca-gip/kubi
RUN make build-operator


FROM scratch
WORKDIR /root/
COPY --from=build /go/src/github.com/ca-gip/kubi/build/kubi-operator .
EXPOSE 8002
CMD ["./kubi-operator"]