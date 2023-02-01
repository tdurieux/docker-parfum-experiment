FROM alpine:3.2

RUN apk --update --no-cache add curl
EXPOSE 80
CMD ["/app"]

COPY app /
