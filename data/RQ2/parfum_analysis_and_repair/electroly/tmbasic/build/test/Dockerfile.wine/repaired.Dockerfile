FROM ubuntu:20.04
RUN apt-get update -y && \
    apt-get upgrade -y
RUN dpkg --add-architecture i386 && \
    apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y wine32 wine64 && rm -rf /var/lib/apt/lists/*;
