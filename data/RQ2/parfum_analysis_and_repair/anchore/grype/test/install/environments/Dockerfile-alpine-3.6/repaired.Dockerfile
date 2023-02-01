FROM alpine:3.6
RUN apk update && apk add --no-cache python3 wget unzip make ca-certificates