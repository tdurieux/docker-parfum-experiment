FROM alpine

RUN apk add --no-cache --update ca-certificates

COPY ./dev/ui /usr/bin/

EXPOSE 3010

ENTRYPOINT ["/usr/bin/ui"]
