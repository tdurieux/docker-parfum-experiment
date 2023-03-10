FROM rust:latest as cargo-build

RUN apt-get update && apt-get install --no-install-recommends clang cmake -y && rm -rf /var/lib/apt/lists/*;

RUN rustup target install x86_64-apple-darwin

WORKDIR /usr/src/main

COPY Cargo.lock Cargo.lock
COPY Cargo.toml Cargo.toml

RUN git clone https://github.com/tpoechtrager/osxcross && \
    cd osxcross && \
    wget -nc https://s3.dockerproject.org/darwin/v2/MacOSX10.10.sdk.tar.xz && \
    mv MacOSX10.10.sdk.tar.xz tarballs/ && \
    UNATTENDED=yes OSX_VERSION_MIN=10.7 ./build.sh && \
    cd ..

RUN mkdir src/

RUN echo "fn main() {println!(\"if you see this, the build cache was invalidated\")}" > src/main.rs

RUN PATH="$PWD/osxcross/target/bin:$PATH" CC="$PWD/osxcross/target/bin/o64-clang" CXX="$PWD/osxcross/target/bin/o64-clang++" RUSTFLAGS="$RUSTFLAGS -C linker=$PWD/osxcross/target/bin/x86_64-apple-darwin14-clang -C ar=$PWD/osxcross/target/bin/x86_64-apple-darwin14-ar" cargo build --release --target=x86_64-apple-darwin

RUN rm -f target/x86_64-apple-darwin/release/deps/snark-setup-operator*

COPY src ./src
COPY LICENSE .
COPY Cargo.lock .
COPY README.md .

RUN mkdir out
RUN PATH="$PWD/osxcross/target/bin:$PATH" CC="$PWD/osxcross/target/bin/o64-clang" CXX="$PWD/osxcross/target/bin/o64-clang++" RUSTFLAGS="$RUSTFLAGS -C linker=$PWD/osxcross/target/bin/x86_64-apple-darwin14-clang -C ar=$PWD/osxcross/target/bin/x86_64-apple-darwin14-ar" cargo build --bin contribute --release --target x86_64-apple-darwin && cp target/x86_64-apple-darwin/release/contribute out/contribute-macos
RUN PATH="$PWD/osxcross/target/bin:$PATH" CC="$PWD/osxcross/target/bin/o64-clang" CXX="$PWD/osxcross/target/bin/o64-clang++" RUSTFLAGS="$RUSTFLAGS -C linker=$PWD/osxcross/target/bin/x86_64-apple-darwin14-clang -C ar=$PWD/osxcross/target/bin/x86_64-apple-darwin14-ar" cargo build --bin generate --release --target x86_64-apple-darwin && cp target/x86_64-apple-darwin/release/generate out/generate-macos
RUN PATH="$PWD/osxcross/target/bin:$PATH" CC="$PWD/osxcross/target/bin/o64-clang" CXX="$PWD/osxcross/target/bin/o64-clang++" RUSTFLAGS="$RUSTFLAGS -C linker=$PWD/osxcross/target/bin/x86_64-apple-darwin14-clang -C ar=$PWD/osxcross/target/bin/x86_64-apple-darwin14-ar" cargo build --bin contribute --release --target x86_64-apple-darwin --no-default-features && cp target/x86_64-apple-darwin/release/contribute out/contribute-macos-noasm
RUN PATH="$PWD/osxcross/target/bin:$PATH" CC="$PWD/osxcross/target/bin/o64-clang" CXX="$PWD/osxcross/target/bin/o64-clang++" RUSTFLAGS="$RUSTFLAGS -C linker=$PWD/osxcross/target/bin/x86_64-apple-darwin14-clang -C ar=$PWD/osxcross/target/bin/x86_64-apple-darwin14-ar" cargo build --bin generate --release --target x86_64-apple-darwin --no-default-features && cp target/x86_64-apple-darwin/release/generate out/generate-macos-noasm