ARG BASE_ALPINE
ARG BASE_GOLANG_16_ALPINE
FROM $BASE_GOLANG_16_ALPINE as artifact
WORKDIR /src/
COPY /app/ /src/
RUN apk add --no-cache git && \
    GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags="-s -w" ./cmd/crowd-basic-auth-proxy

FROM $BASE_ALPINE
COPY --from=artifact /src/crowd-basic-auth-proxy /crowd-basic-auth-proxy
ENTRYPOINT [ "/crowd-basic-auth-proxy" ]
