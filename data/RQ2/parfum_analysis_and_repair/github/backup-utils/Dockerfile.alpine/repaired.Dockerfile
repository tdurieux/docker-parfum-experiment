FROM alpine:latest

RUN apk --update --no-cache add \
    tar \
    rsync \
    ca-certificates \
    openssh \
    git \
    bash \
    gawk \
    procps \
    coreutils

COPY ./ /backup-utils/
WORKDIR /backup-utils

RUN chmod +x /backup-utils/share/github-backup-utils/ghe-docker-init

ENTRYPOINT ["/backup-utils/share/github-backup-utils/ghe-docker-init"]
CMD ["ghe-host-check"]