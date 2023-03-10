# Multistage docker build, requires docker 17.05

# builder stage
FROM rust:1.31 as builder

RUN set -ex && \
    apt-get update && \
    apt-get --no-install-recommends --yes install \
    clang \
    libclang-dev \
    llvm-dev \
    libncurses5 \
    libncursesw5 \
    cmake \
    git && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/epic

# Copying Epic
COPY . .

# Building Epic
RUN cargo build --release

# runtime stage
FROM debian:9.4

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y locales openssl && rm -rf /var/lib/apt/lists/*;

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8

COPY --from=builder /usr/src/epic/target/release/epic /usr/local/bin/epic

WORKDIR /root/.epic

RUN epic --floonet server config && \
    sed -i -e 's/run_tui = true/run_tui = false/' epic-server.toml

VOLUME ["/root/.epic"]

EXPOSE 13413 13414 13415 13416

ENTRYPOINT ["epic", "--floonet"]

CMD ["server", "run"]
