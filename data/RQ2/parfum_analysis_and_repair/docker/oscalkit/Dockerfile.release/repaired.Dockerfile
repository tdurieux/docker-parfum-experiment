FROM alpine:3.7
RUN apk --no-cache add ca-certificates libxml2-utils
ENTRYPOINT ["/oscalkit"]