FROM golang:1.16-stretch as base
WORKDIR /build/
COPY . .
RUN ["make"]

FROM alpine:latest

COPY --from=base /build/compass /usr/bin/compass
RUN ls /usr/bin
RUN apk update
RUN apk add --no-cache ca-certificates

# glibc compatibility library, since go binaries
# don't work well with musl libc that alpine uses
RUN apk add --no-cache libc6-compat

CMD ["compass", "serve"]
