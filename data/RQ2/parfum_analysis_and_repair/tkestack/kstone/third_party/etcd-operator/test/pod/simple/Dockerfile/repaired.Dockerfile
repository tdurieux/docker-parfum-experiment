# golang:X-alpine can't be used since it does not support the race detector flag which assumes a glibc based system, whereas alpine linux uses musl libc
# https://github.com/golang/go/issues/14481