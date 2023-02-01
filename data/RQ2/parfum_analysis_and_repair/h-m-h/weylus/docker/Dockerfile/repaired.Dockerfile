FROM debian:stretch
ENV RUSTUP_HOME="/usr/local/rustup" CARGO_HOME="/usr/local/cargo" PATH="/usr/local/cargo/bin:$PATH"
RUN apt-get update && \
   apt-get install --no-install-recommends -y libx11-dev libxext-dev libxft-dev libxinerama-dev libxcursor-dev \
   libxrender-dev libxfixes-dev libgl1-mesa-dev libglu1-mesa-dev libxtst-dev cmake git curl \
   software-properties-common zip libssl-dev libxrandr-dev libxcomposite-dev libxi-dev \
   gcc g++ autoconf libtool-bin libxv-dev libdrm-dev libpango1.0-dev pkg-config \
   libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libdbus-1-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-add-repository contrib
RUN apt-add-repository non-free
RUN apt-get update && apt-get install --no-install-recommends -y nvidia-cuda-dev && rm -rf /var/lib/apt/lists/*;
RUN curl -f -Lo cmake.tar.gz https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1.tar.gz && tar xf cmake.tar.gz && rm cmake.tar.gz
RUN cd cmake-3.* && cmake . && make -j$(nproc) && make install
RUN rm -rf cmake*
RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    npm install -g typescript && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- -y --default-toolchain stable-x86_64-unknown-linux-gnu
RUN cargo install cargo-deb
RUN curl -f -LO "https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.xz" && \
    tar xf "nasm-2.15.05.tar.xz" && cd "nasm-2.15.05" && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr && make -j$(nproc) && make install && cd .. && rm -rf "nasm-2.15.05*" && rm "nasm-2.15.05.tar.xz"
