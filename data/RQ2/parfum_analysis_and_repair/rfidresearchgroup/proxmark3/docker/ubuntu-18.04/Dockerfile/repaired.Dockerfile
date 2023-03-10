FROM ubuntu:18.04

ENV LANG C
ENV DEBIAN_FRONTEND noninteractive
# qtbase5-dev skipped
# python3 skipped, not yet searchable with pkg-config python3
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y --no-install-recommends git ca-certificates build-essential cmake pkg-config libreadline-dev gcc-arm-none-eabi libnewlib-dev libbz2-dev libbluetooth-dev libssl-dev sudo && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

# Create rrg user
RUN useradd -ms /bin/bash rrg
RUN passwd -d rrg
RUN printf 'rrg ALL=(ALL) ALL\n' | tee -a /etc/sudoers

USER rrg
WORKDIR "/home/rrg"

CMD ["/bin/bash"]
