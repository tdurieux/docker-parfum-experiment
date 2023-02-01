FROM gitpod/workspace-full

RUN sudo apt-get update && sudo apt-get install --no-install-recommends -y \
      pkg-config \
      libsystemd-dev \
      libdbus-1-dev \
      build-essential \
      libelf-dev \
      libseccomp-dev && rm -rf /var/lib/apt/lists/*;

RUN rustup component add clippy rls rust-analysis rust-src rust-docs rustfmt