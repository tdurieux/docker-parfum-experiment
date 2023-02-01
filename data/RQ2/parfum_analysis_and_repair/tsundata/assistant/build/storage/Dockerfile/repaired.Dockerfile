FROM alpine:latest

RUN apk update && apk add --no-cache bash

COPY ./dist/storage_linux_amd64_v1/storage assistant-storage
CMD ["./assistant-storage"]
