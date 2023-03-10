FROM alpine
RUN apk add --no-cache bash ca-certificates

WORKDIR /

COPY bin/neofs-ir /bin/neofs-ir

CMD ["neofs-ir"]