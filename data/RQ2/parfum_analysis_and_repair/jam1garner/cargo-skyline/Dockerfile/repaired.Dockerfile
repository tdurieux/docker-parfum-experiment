FROM devkitpro/devkita64:20210726

USER root
ENV USER root
ENV DEBIAN_FRONTEND=noninteractive

# Install package dependencies.
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    apt-utils \
    curl \
    gcc \
    libssl-dev \
    cmake \
    pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends --reinstall -y coreutils && rm -rf /var/lib/apt/lists/*;

# Necessary for getting glibc, for some reason?
RUN echo "deb http://ftp.us.debian.org/debian testing main contrib non-free" >> /etc/apt/sources.list

RUN apt-get update
RUN apt-get install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;

ENV PATH "$PATH:/opt/devkitpro/devkitA64/bin"

# Install Rust
RUN curl https://sh.rustup.rs -sSf > /tmp/rustup-init.sh \
    && chmod +x /tmp/rustup-init.sh \
    && sh /tmp/rustup-init.sh -y \
    && rm -rf /tmp/rustup-init.sh
ENV PATH "$PATH:~/.cargo/bin"

# Install stable rust.
RUN ~/.cargo/bin/rustup install stable

RUN ~/.cargo/bin/cargo install cargo-skyline

RUN ~/.cargo/bin/cargo skyline update-std
