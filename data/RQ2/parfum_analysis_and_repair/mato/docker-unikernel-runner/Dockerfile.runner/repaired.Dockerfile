# "Runtime" container for mirage-unix runner.

FROM alpine:3.4
RUN apk add --update --no-cache libnl3 libcap-ng
ADD runner.tar.gz /runtime/

# Should be set explicitly downstream.