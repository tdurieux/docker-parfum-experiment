FROM alpine:3.10
RUN apk add --no-cache bash openssh
COPY entry.sh /entry.sh
ENTRYPOINT ["bash", "/entry.sh"]
