FROM alpine:3.13.5

RUN apk update && apk upgrade
RUN apk add --no-cache python3~=3.8 libc-dev
RUN apk add --no-cache gcc~=10.2 gmp-dev~=6.2.1
