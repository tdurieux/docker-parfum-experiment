FROM --platform=linux/amd64 golang:1.16.8-alpine AS build
RUN CGO_ENABLED=0 go get -ldflags "-s -w -extldflags '-static'" github.com/go-delve/delve/cmd/dlv

FROM --platform=linux/amd64 alpine:3.13
COPY --from=build /go/bin/dlv /dlv
ENTRYPOINT [ "/dlv" ]