FROM golang:1.14 as build

WORKDIR $GOPATH/src/

COPY . .

WORKDIR $GOPATH/src/github.com/diadata-org/diadata/cmd/services/itinService

RUN go install

FROM gcr.io/distroless/base

COPY --from=build /go/bin/itinService /bin/itinService

CMD ["itinService"]