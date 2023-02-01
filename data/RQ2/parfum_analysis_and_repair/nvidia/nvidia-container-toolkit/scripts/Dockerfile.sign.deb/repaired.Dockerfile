FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y apt-utils gpg xz-utils && rm -rf /var/lib/apt/lists/*;
