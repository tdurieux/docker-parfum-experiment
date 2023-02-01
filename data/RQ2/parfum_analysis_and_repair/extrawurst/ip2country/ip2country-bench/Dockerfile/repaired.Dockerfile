FROM rust
LABEL maintainer="extrawurst"
RUN apt-get update -y && apt-get install --no-install-recommends -y valgrind && rm -rf /var/lib/apt/lists/*;