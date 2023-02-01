FROM alpine:latest

RUN apk --update --no-cache add bash docker


WORKDIR /app
COPY . .

ENTRYPOINT ["/app/entrypoint.sh"]