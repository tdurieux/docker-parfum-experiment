FROM mato/rumprun-toolchain-hw-x86_64
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
  qemu && rm -rf /var/lib/apt/lists/*;
ENV PATH=$PATH:/rust/bin \
    CARGO_TARGET_X86_64_RUMPRUN_NETBSD_RUNNER=/tmp/runtest

ADD docker/x86_64-rumprun-netbsd/runtest.rs /tmp/
ENTRYPOINT ["sh", "-c", "rustc /tmp/runtest.rs -o /tmp/runtest && exec \"$@\"", "--"]
