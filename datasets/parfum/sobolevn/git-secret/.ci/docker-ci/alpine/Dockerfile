FROM alpine:3.16.0

LABEL maintainer="mail@sobolevn.me"
LABEL vendor="git-secret team"

# Don't install coreutils on Alpine,
# so we get busybox versions of ps, stat, and ls. See #475
RUN apk add --no-cache --update \
  # Direct dependencies:
  bash \
  gawk \
  git \
  gnupg \
  # Assumed to be present:
  file \
  make \
  procps
