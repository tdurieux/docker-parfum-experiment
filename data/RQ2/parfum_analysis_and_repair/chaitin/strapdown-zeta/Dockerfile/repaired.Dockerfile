FROM alpine
ADD server/strapdown-server /strapdown-server
RUN apk update && apk add --no-cache ca-certificates
ENTRYPOINT ["/strapdown-server"]
