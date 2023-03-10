ARG BASE=focal
FROM ubuntu:$BASE

ARG build_dir=build-embedded

# Run security updates
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y xz-utils && rm -rf /var/lib/apt/lists/*

COPY /$build_dir/src/bpftrace /usr/bin/bpftrace
COPY /tools/*.bt /usr/local/bin/
