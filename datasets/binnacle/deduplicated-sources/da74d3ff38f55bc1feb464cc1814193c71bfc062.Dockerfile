FROM golang:alpine as build
ARG VERSION=unspecified
RUN apk --no-cache add git
ENV PACKAGEPATH=github.com/networkservicemesh/networkservicemesh/
ENV GO111MODULE=on

RUN mkdir /root/networkservicemesh
ADD ["go.mod","/root/networkservicemesh"]
ADD ["./scripts/go-mod-download.sh","/root/networkservicemesh"]
WORKDIR /root/networkservicemesh/
RUN ./go-mod-download.sh

ADD [".","/root/networkservicemesh"]
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-extldflags "-static" -X  main.version=${VERSION}" -o /go/bin/nsmd-k8s ./k8s/cmd/nsmd-k8s/main.go

FROM alpine as runtime
COPY --from=build /go/bin/nsmd-k8s /bin/nsmd-k8s
ENTRYPOINT ["/bin/nsmd-k8s"]
