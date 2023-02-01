FROM alpine:3.10 as builder
RUN apk add --no-cache g++ curl-dev
WORKDIR /
COPY curl.c /

RUN g++ -g -fPIC -Wall -o /curl /curl.c -lcurl

FROM alpine:3.10
RUN apk add --no-cache curl
COPY --from=builder /curl /curl
