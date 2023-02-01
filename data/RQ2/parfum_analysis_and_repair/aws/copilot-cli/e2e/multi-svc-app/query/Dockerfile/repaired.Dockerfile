FROM alpine:latest
RUN apk add --no-cache curl
WORKDIR /home
COPY . .
CMD ["/bin/sh", "entrypoint.sh"]