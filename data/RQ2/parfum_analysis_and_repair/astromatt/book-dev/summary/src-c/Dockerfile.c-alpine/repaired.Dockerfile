FROM alpine
RUN apk add --no-cache gcc musl-dev make libpcap-dev
WORKDIR /data