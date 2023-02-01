FROM debian:bullseye-20220328

RUN set -x; \
    apt-get update && \
    apt-get install --no-install-recommends -y curl openssh-client gnupg gpg-agent git make && \
    rm -rf /var/lib/apt/lists/*