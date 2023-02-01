FROM alpine
RUN apk add --no-cache --update curl && rm -rf /var/cache/apk/*

ADD pricer /

EXPOSE 8080

ENTRYPOINT [ "/pricer" ]