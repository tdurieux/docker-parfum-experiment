FROM golang:1.15 AS build
WORKDIR /jsso2

COPY go.mod go.sum /jsso2/
RUN go mod download

COPY . /jsso2/
ARG version="unversioned-docker-build"
RUN CGO_ENABLED=0 go install -ldflags "-X github.com/jrockway/opinionated-server/server.AppVersion=${version}" ./cmd/jsso2
RUN CGO_ENABLED=0 go install -ldflags "-X github.com/jrockway/opinionated-server/server.AppVersion=${version}" ./cmd/jsso2-envoy-authz

FROM gcr.io/distroless/static-debian10
WORKDIR /
COPY --from=build /go/bin/jsso2 /go/bin/jsso2
COPY --from=build /go/bin/jsso2-envoy-authz /go/bin/jsso2-envoy-authz
COPY --from=build /jsso2/migrations/ /migrations/
CMD ["/go/bin/jsso2"]