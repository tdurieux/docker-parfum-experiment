from guangie88/rustfmt-clippy:nightly

run cargo install hyperfine watchexec

run apt-get update && apt-get install --no-install-recommends -y valgrind && rm -rf /var/lib/apt/lists/*;

env PATH=$PATH:/root/.cargo/bin
