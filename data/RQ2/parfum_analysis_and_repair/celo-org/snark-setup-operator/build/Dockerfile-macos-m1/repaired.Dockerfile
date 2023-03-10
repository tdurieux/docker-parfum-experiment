FROM rust:latest as cargo-build

RUN apt-get update && apt-get install --no-install-recommends clang cmake -y && rm -rf /var/lib/apt/lists/*;

RUN rustup install beta && rustup +beta target install aarch64-apple-darwin

WORKDIR /usr/src/main

COPY Cargo.lock Cargo.lock
COPY Cargo.toml Cargo.toml

RUN git clone https://github.com/tpoechtrager/osxcross && \
    cd osxcross && \
    wget -nc https://celoosxcross.blob.core.windows.net/sdk/MacOSX11.0.sdk.tar.bz2 && \
    mv MacOSX11.0.sdk.tar.bz2 tarballs/ && \
    UNATTENDED=yes OSX_VERSION_MIN=11.0 ./build.sh && \
    cd ..

RUN mkdir src/

RUN echo "fn main() {println!(\"if you see this, the build cache was invalidated\")}" > src/main.rs

RUN PATH="$PWD/osxcross/target/bin:$PATH" CC="$PWD/osxcross/target/bin/arm64-apple-darwin20.1-clang" CXX="$PWD/osxcross/target/bin/arm64-apple-darwin20.1-clang++" RUSTFLAGS="$RUSTFLAGS -C linker=$PWD/osxcross/target/bin/arm64-apple-darwin20.1-clang -C ar=$PWD/osxcross/target/bin/arm64-apple-darwin20.1-ar" cargo +beta build --release --target=aarch64-apple-darwin

RUN rm -f target/aarch64-apple-darwin/release/deps/snark-setup-operator*

COPY src ./src
COPY LICENSE .
COPY Cargo.lock .
COPY README.md .

RUN mkdir out
RUN PATH="$PWD/osxcross/target/bin:$PATH" CC="$PWD/osxcross/target/bin/arm64-apple-darwin20.1-clang" CXX="$PWD/osxcross/target/bin/arm64-apple-darwin20.1-clang++" RUSTFLAGS="$RUSTFLAGS -C linker=$PWD/osxcross/target/bin/arm64-apple-darwin20.1-clang -C ar=$PWD/osxcross/target/bin/arm64-apple-darwin20.1-ar" cargo +beta build --bin contribute --release --target aarch64-apple-darwin && cp target/aarch64-apple-darwin/release/contribute out/contribute-macos-m1
RUN PATH="$PWD/osxcross/target/bin:$PATH" CC="$PWD/osxcross/target/bin/arm64-apple-darwin20.1-clang" CXX="$PWD/osxcross/target/bin/arm64-apple-darwin20.1-clang++" RUSTFLAGS="$RUSTFLAGS -C linker=$PWD/osxcross/target/bin/arm64-apple-darwin20.1-clang -C ar=$PWD/osxcross/target/bin/arm64-apple-darwin20.1-ar" cargo +beta build --bin generate --release --target aarch64-apple-darwin && cp target/aarch64-apple-darwin/release/generate out/generate-macos-m1
RUN PATH="$PWD/osxcross/target/bin:$PATH" CC="$PWD/osxcross/target/bin/arm64-apple-darwin20.1-clang" CXX="$PWD/osxcross/target/bin/arm64-apple-darwin20.1-clang++" RUSTFLAGS="$RUSTFLAGS -C linker=$PWD/osxcross/target/bin/arm64-apple-darwin20.1-clang -C ar=$PWD/osxcross/target/bin/arm64-apple-darwin20.1-ar" cargo +beta build --bin contribute --release --target aarch64-apple-darwin --no-default-features && cp target/aarch64-apple-darwin/release/contribute out/contribute-macos-m1-noasm
RUN PATH="$PWD/osxcross/target/bin:$PATH" CC="$PWD/osxcross/target/bin/arm64-apple-darwin20.1-clang" CXX="$PWD/osxcross/target/bin/arm64-apple-darwin20.1-clang++" RUSTFLAGS="$RUSTFLAGS -C linker=$PWD/osxcross/target/bin/arm64-apple-darwin20.1-clang -C ar=$PWD/osxcross/target/bin/arm64-apple-darwin20.1-ar" cargo +beta build --bin generate --release --target aarch64-apple-darwin --no-default-features && cp target/aarch64-apple-darwin/release/generate out/generate-macos-m1-noasm
