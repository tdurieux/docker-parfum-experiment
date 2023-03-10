FROM alpine:3.13
RUN apk add --no-cache ca-certificates openssh-client
COPY rancher /usr/bin/
WORKDIR /mnt
ENTRYPOINT ["rancher"]
CMD  ["--help"]