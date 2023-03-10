FROM alpine
RUN apk add --no-cache bash ca-certificates

WORKDIR /

COPY bin/neofs-adm /bin/neofs-adm

CMD ["neofs-adm"]