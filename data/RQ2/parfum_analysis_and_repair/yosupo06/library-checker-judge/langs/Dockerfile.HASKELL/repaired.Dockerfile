FROM ekidd/rust-musl-builder:latest as init-builder
COPY --chown=rust:rust init .
RUN cargo build --release

FROM haskell:9.0.2-slim

RUN stack install --resolver lts-19.6 array bytestring containers deepseq hashable heaps io-streams lens mutable-containers massiv mono-traversable mtl random strict text transformers vector vector-algorithms word8
COPY haskell_load.hs /tmp/
RUN stack ghc -- /tmp/haskell_load.hs

COPY --from=init-builder /home/rust/src/target/x86_64-unknown-linux-musl/release/library-checker-init /usr/bin