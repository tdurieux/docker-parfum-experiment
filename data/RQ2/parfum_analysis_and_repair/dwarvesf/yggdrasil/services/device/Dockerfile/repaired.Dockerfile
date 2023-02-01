FROM alpine:3.7
RUN apk add --no-cache --no-cach ca-certificates
WORKDIR /
COPY server /server
ENTRYPOINT ["/server"]
