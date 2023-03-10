FROM golang:1.13-alpine as build
WORKDIR /deploy-metering

COPY build ./build
COPY hack/codegen_source_files.sh hack/codegen_output_files.sh ./hack/
COPY Makefile ./Makefile
COPY cmd/deploy-metering ./cmd/deploy-metering
COPY pkg ./pkg
COPY manifests/deploy ./manifests/deploy
COPY go.mod go.sum ./
RUN apk --no-cache add make bash && make bin/deploy-metering GO_BUILD_ARGS=""

FROM alpine:3

RUN mkdir /manifests
COPY --from=build /deploy-metering/bin/deploy-metering /bin/deploy-metering
COPY --from=build /deploy-metering/manifests/deploy /manifests/deploy

ENTRYPOINT ["/bin/deploy-metering", "--deploy-manifests-dir", "/manifests/deploy"]