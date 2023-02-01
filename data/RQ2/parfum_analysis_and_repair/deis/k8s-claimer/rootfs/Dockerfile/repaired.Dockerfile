FROM alpine:3.4

RUN apk add --no-cache -U ca-certificates openssh bash && rm -rf /var/cache/apk/*

COPY bin/ /bin/
EXPOSE 8080

ENTRYPOINT ["start"]
