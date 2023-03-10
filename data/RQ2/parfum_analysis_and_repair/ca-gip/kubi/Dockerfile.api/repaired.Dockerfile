FROM golang:latest as build
WORKDIR $GOPATH/src/github.com/ca-gip/kubi
COPY . $GOPATH/src/github.com/ca-gip/kubi
RUN make build-api

FROM scratch
WORKDIR /root/
COPY --from=build /go/src/github.com/ca-gip/kubi/build/kubi-api .
EXPOSE 8000
CMD ["./kubi-api"]