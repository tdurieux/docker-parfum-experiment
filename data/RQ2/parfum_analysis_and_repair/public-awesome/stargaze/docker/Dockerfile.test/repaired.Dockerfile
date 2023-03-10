FROM alpine:3.15
RUN apk add -U --no-cache ca-certificates

WORKDIR /root
COPY ./bin/starsd /usr/bin/starsd
COPY ./docker/test-entry-point.sh ./entry-point.sh
EXPOSE 26657

ENTRYPOINT [ "./entry-point.sh" ]