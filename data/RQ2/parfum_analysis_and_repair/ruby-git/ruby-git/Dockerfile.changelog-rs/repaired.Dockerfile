FROM rust

# Build the docker image (from this project's root directory):
# docker build --file Dockerfile.changelog-rs --tag changelog-rs .
#
# Use this image to output a changelog (from this project's root directory):
# docker run --rm --volume "$PWD:/worktree" changelog-rs v1.9.1 v1.10.0

RUN cargo install changelog-rs
WORKDIR /worktree

ENTRYPOINT ["/usr/local/cargo/bin/changelog-rs", "/worktree"]