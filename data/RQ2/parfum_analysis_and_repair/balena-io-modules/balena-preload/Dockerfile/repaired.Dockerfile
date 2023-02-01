# avoid alpine 3.13 or later due to this issue on armv7
# https://wiki.alpinelinux.org/wiki/Release_Notes_for_Alpine_3.13.0#time64_requirements
FROM alpine:3.12

WORKDIR /usr/src/app

# coreutils so we have the real dd, not the busybox one
# hadolint ignore=DL3018