FROM golang:1.10-alpine AS compile
COPY . /go/src/github.com/containerbuilding/cbi
RUN go build -ldflags="-s -w" -o /cbi-gcb github.com/containerbuilding/cbi/cmd/cbi-gcb

FROM alpine:3.7
COPY --from=compile /cbi-gcb /cbi-gcb
ENTRYPOINT ["/cbi-gcb"]