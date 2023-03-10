FROM alpine:3.14

RUN apk --no-cache add ca-certificates
COPY  kconnect /

RUN adduser -D kconnect
USER kconnect
ENTRYPOINT ["/kconnect"]