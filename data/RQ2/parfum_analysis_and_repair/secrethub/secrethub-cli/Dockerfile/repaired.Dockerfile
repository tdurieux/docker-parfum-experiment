FROM golang:1.14-alpine as build_base
WORKDIR /build
ENV GO111MODULE=on
RUN apk add --no-cache --update git
COPY go.mod .
COPY go.sum .
RUN go mod download

FROM build_base as build
RUN apk add --no-cache --update make
COPY . .
RUN make build

FROM alpine
COPY --from=build /build/secrethub /usr/bin/secrethub
RUN apk add --no-cache ca-certificates && \
    update-ca-certificates
ENTRYPOINT ["secrethub"]
