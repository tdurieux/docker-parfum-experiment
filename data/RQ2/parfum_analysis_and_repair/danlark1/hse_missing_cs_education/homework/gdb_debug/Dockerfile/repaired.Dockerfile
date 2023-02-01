FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y g++ gdb && rm -rf /var/lib/apt/lists/*;

COPY with_symbols /opt

COPY without_symbols /opt

COPY with_core /opt

COPY coredump /opt

COPY flaky /opt
