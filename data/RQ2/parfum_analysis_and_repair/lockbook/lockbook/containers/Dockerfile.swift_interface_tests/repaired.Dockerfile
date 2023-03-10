FROM swift

# Get rusty
RUN apt update && apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo install cbindgen
RUN cargo install cargo-lipo
RUN rustup target add aarch64-apple-ios x86_64-apple-ios

# Build corelib for iOS
COPY . .
WORKDIR core
# This will cause problems for you during tests
ENV API_URL=http://lockbook_server:8000
RUN make lib_c_for_swift_native

# Build Swift Package
COPY clients/apple ../clients/apple
WORKDIR ../clients/apple/SwiftLockbookCore
RUN swift build
