FROM ubuntu:xenial
RUN apt-get update && apt-get install --no-install-recommends -y expect coreutils && rm -rf /var/lib/apt/lists/*;
