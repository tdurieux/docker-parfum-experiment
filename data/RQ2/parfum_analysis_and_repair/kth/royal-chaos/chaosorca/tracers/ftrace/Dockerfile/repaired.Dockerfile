FROM ubuntu:bionic
RUN apt-get update && apt-get install --no-install-recommends -y \
    trace-cmd && rm -rf /var/lib/apt/lists/*;
