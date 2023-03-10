FROM alpine
RUN apk add --no-cache bash ca-certificates

WORKDIR /

COPY bin/neofs-cli /bin/neofs-cli

CMD ["neofs-cli"]