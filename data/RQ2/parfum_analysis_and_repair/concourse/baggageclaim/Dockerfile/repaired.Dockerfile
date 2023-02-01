FROM golang:1

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -yqq \
          file \
          btrfs-progs && rm -rf /var/lib/apt/lists/*;
