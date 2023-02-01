FROM alpine:3.13

WORKDIR /home

RUN apk add --no-cache -U wireguard-tools

COPY ./bin/linux_amd64/drago ./drago

ENTRYPOINT [ "./drago" ]