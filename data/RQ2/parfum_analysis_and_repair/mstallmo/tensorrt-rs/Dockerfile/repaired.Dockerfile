FROM nvcr.io/nvidia/tensorrt:20.11-py3

RUN apt-get update
RUN apt install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update
RUN apt-get install --no-install-recommends g++-7 -y && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 \
    --slave /usr/bin/g++ g++ /usr/bin/g++-7
RUN update-alternatives --config gcc
RUN gcc --version
RUN g++ --version
RUN apt-get update
RUN apt-get install --no-install-recommends clang-6.0 -y && rm -rf /var/lib/apt/lists/*;

# Download and install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

#Add Cargo executables to path
ENV PATH="/root/.cargo/bin:${PATH}"

# Check version
RUN cargo --version
