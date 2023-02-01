FROM alpine:latest
RUN apk update && apk add --no-cache ca-certificates && rm -rf /var/cache/apk/*
ADD ./out/server-bin .
ENV PORT 8080
CMD ["./server-bin"]