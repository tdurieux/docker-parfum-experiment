FROM golang:1.14-stretch

ARG SERVICE

COPY ./bin/$SERVICE /app/main
COPY ./config.yml /config/
ENTRYPOINT ["/app/main", "-c", "/config/config.yml"]