FROM alpine:latest as certs
RUN apk --update --no-cache add ca-certificates

FROM scratch
ENV PATH=/bin
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY lokalise2 /bin/lokalise2

CMD ["/bin/lokalise2"]
