FROM ubuntu:20.10

ENV DEBIAN_FRONTEND=noninteractive \
    PATH=/root/.cargo/bin:$PATH

WORKDIR /opt/kime

RUN apt-get update
RUN apt-get install --no-install-recommends -y curl apt-utils && rm -rf /var/lib/apt/lists/*;
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --no-modify-path --profile minimal
RUN rustc --version
RUN apt-get install --no-install-recommends -y build-essential git gcc libclang-10-dev cmake extra-cmake-modules pkg-config zstd && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libpango1.0-dev libcairo2-dev libgtk2.0-dev libgtk-3-dev libglib2.0 libxcb1 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y qtbase5-dev qtbase5-private-dev libqt5gui5 && rm -rf /var/lib/apt/lists/*;
RUN mkdir -pv /opt/kime-out

COPY src ./src

COPY Cargo.toml .
COPY Cargo.lock .

RUN cargo fetch

COPY res ./res
COPY ci ./ci
COPY docs ./docs
COPY scripts ./scripts
COPY LICENSE .
COPY NOTICE.md .
COPY README.ko.md .
COPY README.md .
COPY VERSION .

ENTRYPOINT [ "ci/build_deb.sh" ]
