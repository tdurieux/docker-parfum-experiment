#############################################
# Build
#############################################
FROM --platform=$BUILDPLATFORM golang:1.18-alpine as build

RUN apk upgrade --no-cache --force
RUN apk add --no-cache --update build-base make git

WORKDIR /go/src/github.com/webdevops/go-crond

# Dependencies
COPY go.mod go.sum .
RUN go mod download

# Compile
COPY . .
RUN make test
ARG TARGETOS TARGETARCH
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} make build

#############################################
# Test
#############################################
FROM gcr.io/distroless/static as test
USER 0:0
WORKDIR /app
COPY --from=build /go/src/github.com/webdevops/go-crond/go-crond .
RUN ["./go-crond", "--help"]

#############################################
# FINAL IMAGE
#############################################
FROM ubuntu:latest
ENV SERVER_BIND=":8080" \
    SERVER_METRICS="1" \
    LOG_JSON="1"
COPY --from=test /app /usr/local/bin
EXPOSE 8080
ENTRYPOINT ["go-crond"]
