FROM alpine:3.1
ADD ./dist/maestro /usr/bin/maestro
ENTRYPOINT ["/usr/bin/maestro"]