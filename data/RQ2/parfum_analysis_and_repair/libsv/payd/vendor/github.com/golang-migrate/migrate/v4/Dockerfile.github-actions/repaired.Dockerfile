FROM alpine:3.13

RUN apk add --no-cache ca-certificates

COPY migrate /usr/bin/migrate
RUN ln -s /usr/bin/migrate /migrate

ENTRYPOINT ["migrate"]
CMD ["--help"]