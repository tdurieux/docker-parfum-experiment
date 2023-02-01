FROM namely/protoc
FROM alpine:3.9

RUN apk add --no-cache bash libstdc++
COPY --from=0 /usr/local/bin/protoc /usr/local/bin/protoc


