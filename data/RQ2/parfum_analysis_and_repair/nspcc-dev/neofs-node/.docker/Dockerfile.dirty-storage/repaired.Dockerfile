FROM alpine
RUN apk add --no-cache bash ca-certificates

WORKDIR /

COPY bin/neofs-node /bin/neofs-node

CMD ["neofs-node"]