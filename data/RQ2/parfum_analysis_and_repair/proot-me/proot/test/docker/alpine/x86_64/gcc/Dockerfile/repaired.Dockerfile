FROM proot-me/proot:alpine-x86_64

RUN apk add --no-cache \
      --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
      gcc \
      gdb \
      lcov

