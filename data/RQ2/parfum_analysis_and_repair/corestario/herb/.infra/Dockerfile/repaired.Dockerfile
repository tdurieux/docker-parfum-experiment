FROM alpine:3.10

RUN apk add --no-cache bash# required for automated chain generation

COPY dist/ /usr/local/bin/

CMD ["/usr/local/bin/hd", "start"]
