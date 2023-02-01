FROM ubuntu:22.04

ADD ubuntu22_sources.list /etc/apt/sources.list
RUN touch /etc/apt/apt.conf.d/99verify-peer.conf \
&& echo >>/etc/apt/apt.conf.d/99verify-peer.conf "Acquire { https::Verify-Peer false }"


RUN echo 'Asia/Shanghai' >/etc/timezone

# Update new packages
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y \
    build-essential \
    make \
    g++ \
    gcc \
    git \
    vim \
    cmake \
    sudo \
    curl \
    python3 \
    pip \
    cloc && rm -rf /var/lib/apt/lists/*;

RUN git clone --branch v1.6.1 https://gitee.com/mirrors/google-benchmark benchmark && \
        cd benchmark && \
        git clone --branch release-1.11.0 https://gitee.com/mirrors/googletest && \
        cmake -E make_directory "build" && \
        cmake -E chdir "build" cmake -DBENCHMARK_DOWNLOAD_DEPENDENCIES=on -DCMAKE_BUILD_TYPE=Release ../ && \
        cmake --build "build" --config Release -j && \
        sudo cmake --build "build" --config Release --target install -j


# Get Rust
# change source of Rust
ADD rust_config /root/.cargo/config
ENV RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
ENV RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

ENV PATH="/root/.cargo/bin:${PATH}"

RUN apt-get install --no-install-recommends -y \
    ninja-build \
    valgrind \
    mingw-w64 \
    mingw-w64-tools \
    mingw-w64-i686-dev \
    mingw-w64-x86-64-dev \
    wine \
    cbindgen && rm -rf /var/lib/apt/lists/*;

# only need on ubuntu20.04
# RUN dpkg --add-architecture i386 && apt-get update && apt-get install wine32 -y

RUN apt-get install --no-install-recommends -y golang && rm -rf /var/lib/apt/lists/*;
RUN go env -w GO111MODULE=on
RUN go env -w GOPROXY=https://goproxy.cn


RUN git clone https://gitee.com/lyon1998/pikascript  root/pikascript
RUN cd /root/pikascript && git pull

RUN rustup target add i686-pc-windows-gnu
RUN cd /root/pikascript/tools/pikaCompiler && sh build.sh

ADD .vimrc /root/.vimrc

ADD bashrc /root/.bashrc
RUN apt-get install --no-install-recommends -y liblua5.3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y lcov && rm -rf /var/lib/apt/lists/*;
