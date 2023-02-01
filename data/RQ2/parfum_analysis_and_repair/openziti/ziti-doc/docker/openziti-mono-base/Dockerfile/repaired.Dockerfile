FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# mono and dependencies install
RUN apt update && \
    apt install --no-install-recommends -y gnupg ca-certificates && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt install --no-install-recommends -y vim wget unzip curl awscli git ssh && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y mono-devel && \
    rm -rf /var/lib/apt/lists/* /tmp/*