FROM golang:1.17 as build

WORKDIR /go/src/makeless-go
COPY ./backend /go/src/makeless-go
COPY ./makeless.json /go/src/makeless-go

RUN go build -o /go/bin/makeless-go

FROM gcr.io/distroless/base

COPY --from=build /go/bin/makeless-go /
COPY --from=build /go/src/makeless-go/makeless.json /
CMD ["/makeless-go"]