FROM alpine:latest as certs
RUN apk --update --no-cache add ca-certificates && update-ca-certificates

FROM scratch
ENV USER docker
ENV BROKERS localhost:9092
COPY kafkactl /
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["/kafkactl"]