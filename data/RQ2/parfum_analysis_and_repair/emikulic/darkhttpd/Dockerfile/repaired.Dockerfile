# Build environment
FROM alpine AS build
RUN apk add --no-cache build-base
WORKDIR /src
COPY . .
RUN make darkhttpd-static \
 && strip darkhttpd-static

# Just the static binary