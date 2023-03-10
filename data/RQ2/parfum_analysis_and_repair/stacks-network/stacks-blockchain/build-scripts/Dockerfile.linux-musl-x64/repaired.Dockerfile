FROM rust:stretch as build

ARG STACKS_NODE_VERSION="No Version Info"
ARG GIT_BRANCH='No Branch Info'
ARG GIT_COMMIT='No Commit Info'

WORKDIR /src

COPY . .

RUN rustup target add x86_64-unknown-linux-musl

RUN apt-get update && apt-get install --no-install-recommends -y git musl-tools && rm -rf /var/lib/apt/lists/*;

RUN CC=musl-gcc \
    CC_x86_64_unknown_linux_musl=musl-gcc \
    CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_LINKER=musl-gcc \
    cargo build --release --workspace --target x86_64-unknown-linux-musl

RUN mkdir /out && cp -R /src/target/x86_64-unknown-linux-musl/release/. /out

FROM scratch AS export-stage
COPY --from=build /out/stacks-inspect /out/blockstack-cli /out/clarity-cli /out/stacks-node /