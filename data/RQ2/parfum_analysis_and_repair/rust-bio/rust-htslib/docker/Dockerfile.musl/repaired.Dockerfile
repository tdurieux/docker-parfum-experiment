FROM brainstorm/cross-x86_64-unknown-linux-musl:upstream

ENV DEBIAN_FRONTEND noninteractive
ENV PKG_CONFIG_ALLOW_CROSS 1

ENV LIBCLANG_PATH /usr/lib/llvm-10/lib
ENV LLVM_CONFIG_PATH /usr/bin

WORKDIR /root

# Otherwise LLVM bump below fails
RUN apt-get install --no-install-recommends -y wget gnupg lsb-release software-properties-common apt-transport-https ca-certificates && rm -rf /var/lib/apt/lists/*;

# Autodetect and fetch latest LLVM repos for the current distro, avoids LLVM warnings and other issues, might generate slower builds for now though, see:
# https://www.phoronix.com/scan.php?page=news_item&px=Rust-Hurt-On-LLVM-10
RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
