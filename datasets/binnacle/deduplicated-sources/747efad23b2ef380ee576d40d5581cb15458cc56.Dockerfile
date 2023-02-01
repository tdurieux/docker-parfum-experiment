FROM golang:alpine as build
ARG VERSION=unspecified
ENV PACKAGEPATH=github.com/networkservicemesh/networkservicemesh/
COPY [".","/go/src/${PACKAGEPATH}"]
WORKDIR /go/src/${PACKAGEPATH}/
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-extldflags "-static" -X  main.version=${VERSION}" -o /go/bin/nsm-generate-sriov-configmap ./test/applications/cmd/nsm-generate-sriov-configmap
FROM alpine as runtime
COPY --from=build /go/bin/nsm-generate-sriov-configmap /bin/nsm-generate-sriov-configmap
ENTRYPOINT ["/bin/nsm-generate-sriov-configmap"]
