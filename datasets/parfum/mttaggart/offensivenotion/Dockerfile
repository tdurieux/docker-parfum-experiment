FROM rust:latest AS rustbuilder

# Do the Rust setup, but do it just the once and separate the ON stuff

RUN echo "Installing dependencies"
RUN apt update
RUN apt install -y \ 
    mingw-w64 \ 
    gcc-multilib \ 
    python3-pip \
    cmake \
    clang \
    gcc \
    g++ \
    zlib1g-dev \
    libmpc-dev \
    libmpfr-dev \
    libgmp-dev

RUN rustup toolchain install nightly
RUN rustup default nightly
RUN rustup target add x86_64-pc-windows-gnu
RUN rustup target add x86_64-apple-darwin


# Now we get to work
# FROM ubuntu:latest as onbuilder

RUN mkdir /OffensiveNotion
RUN mkdir /OffensiveNotion/agent
RUN mkdir /OffensiveNotion/agent/src
RUN mkdir /OffensiveNotion/agent/target
RUN mkdir /out
# We're going to be more explicit about this copy over to save space in the image
# Also, a fun hack to get the config.json if it exists, but copy the rest regardless
COPY ./main.py ./requirements.txt config.jso[n] /OffensiveNotion/
COPY ./utils /OffensiveNotion/utils
COPY ./agent/Cargo.toml ./agent/build.rs ./agent/offensive_notion.rc ./agent/notion.ico /OffensiveNotion/agent/
COPY ./agent/src/ /OffensiveNotion/agent/src/

WORKDIR /OffensiveNotion

# MacOS install. If not building a macOS agent, feel free to comment this RUN command out.
RUN git clone https://github.com/tpoechtrager/osxcross && cd osxcross && wget -nc https://s3.dockerproject.org/darwin/v2/MacOSX10.10.sdk.tar.xz && mv MacOSX10.10.sdk.tar.xz tarballs/ && echo "[*] Building osxcross. This may take a while..." &&UNATTENDED=yes OSX_VERSION_MIN=10.7 ./build.sh > /dev/null 2>&1 && echo "[+] Done!"

RUN pip3 install -r requirements.txt
ENTRYPOINT ["/usr/bin/python3", "main.py"]