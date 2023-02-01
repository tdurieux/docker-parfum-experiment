FROM alpine:latest

RUN apk -U upgrade

RUN mkdir -p /tmp
 
WORKDIR /tmp

EXPOSE 8080

COPY dpg-web /tmp
COPY index.html /tmp

CMD ["/tmp/dpg-web"]