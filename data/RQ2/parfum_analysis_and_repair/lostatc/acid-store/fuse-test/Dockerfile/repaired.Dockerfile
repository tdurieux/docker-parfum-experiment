FROM rust:latest AS rust-build
USER root
WORKDIR /usr/src
COPY ./fuse-test/fuse-mount ./fuse-mount
COPY ./src ./acid-store/src
COPY ./Cargo.toml ./acid-store/Cargo.toml
RUN apt-get -yq update
RUN apt-get -yq --no-install-recommends install libfuse-dev libacl1-dev pkg-config && rm -rf /var/lib/apt/lists/*;
RUN cargo install --path ./fuse-mount

FROM yujunz/secfs.test
COPY ./fuse-test/fstest.patch ./fstest/fstest-acid-store.patch
COPY --from=rust-build /usr/local/cargo/bin/fuse-mount ./fuse-mount
RUN apt-get -yq --no-install-recommends install fuse acl bc git && rm -rf /var/lib/apt/lists/*;
RUN git apply ./fstest/fstest-acid-store.patch
