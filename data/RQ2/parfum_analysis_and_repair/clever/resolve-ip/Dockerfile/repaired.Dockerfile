FROM alpine:3.10

COPY GeoLiteCity /GeoLiteCity

RUN apk add --no-cache ca-certificates && update-ca-certificates
COPY bin/resolve-ip /bin/resolve-ip

CMD ["/bin/resolve-ip", "--addr=0.0.0.0:80"]
