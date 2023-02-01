FROM nvidia/vulkan:1.2.133-450 AS rust-vulkan
RUN apt-get update && apt-get install --no-install-recommends -y apt-utils && apt-get -y dist-upgrade && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl git gcc g++ libssl-dev pkg-config && rm -rf /var/lib/apt/lists/*;
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN /root/.cargo/bin/cargo install cargo-make
