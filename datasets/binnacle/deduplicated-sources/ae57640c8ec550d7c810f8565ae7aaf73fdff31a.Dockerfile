FROM alpine:latest
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
#COPY --from=slotix/dfk-binary /go/src/github.com/slotix/dataflowkit/cmd/parse.d/parse.d /
COPY parse.d /
EXPOSE 8002
ENTRYPOINT ./parse.d