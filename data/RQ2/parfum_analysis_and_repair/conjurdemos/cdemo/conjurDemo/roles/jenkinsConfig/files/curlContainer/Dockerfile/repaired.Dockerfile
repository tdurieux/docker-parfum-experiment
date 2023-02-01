FROM alpine

RUN apk add --no-cache --update bash && rm -rf /var/cache/apk/*
RUN apk add --no-cache --update curl && rm -rf /var/cache/apk/*
COPY container_client.sh /root/container_client.sh
LABEL LAB="2"
RUN chmod +x /root/container_client.sh
