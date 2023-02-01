ARG RUST_VERSION=1.61.0

FROM ubuntu:18.04 as build

ARG RUST_VERSION

COPY ton-node /tonlabs/ton-node/

# install deps
ENV TZ=Europe/Moscow
ENV PATH="/root/.cargo/bin:${PATH}"
#ENV RUST_BACKTRACE=1

RUN apt-get update && apt-get install --no-install-recommends -y curl gnupg2 && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && rm -rf /var/lib/apt/lists/*;

RUN echo "deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse" >> /etc/apt/sources.list; \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 871920D1991BC93C; \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32; \
    apt-get update && apt-get install --no-install-recommends -y \
    gpg \
    tar \
    cmake \
    build-essential \
    pkg-config \
    libssl-dev \
    libtool \
    m4 \
    automake \
    clang \
    git \
    libzstd-dev \
    libgoogle-perftools-dev && rm -rf /var/lib/apt/lists/*;

ENV ZSTD_LIB_DIR=/usr/lib/x86_64-linux-gnu

# rdkafka from confluent's repo
RUN curl -f https://packages.confluent.io/deb/5.5/archive.key | apt-key add; \
    echo "deb [arch=amd64] https://packages.confluent.io/deb/5.5 stable main" >> /etc/apt/sources.list; \
    apt-get update; \
    apt-get install --no-install-recommends -y librdkafka-dev; rm -rf /var/lib/apt/lists/*;

# Get Rust
COPY rust_install.sh /tmp/rust_install.sh

RUN bash -c "/tmp/rust_install.sh ${RUST_VERSION}"

WORKDIR /tonlabs/ton-node
#RUN cargo update && cargo build --release --features "external_db,metrics,compression"
RUN cargo update && cargo build --release --features "external_db,metrics"

FROM ubuntu:18.04 as build2

ARG RUST_VERSION

ENV TZ=Europe/Moscow

RUN apt-get update && apt-get install --no-install-recommends -y curl gnupg2 && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://packages.confluent.io/deb/5.5/archive.key | apt-key add
RUN echo "deb [arch=amd64] https://packages.confluent.io/deb/5.5 stable main" >> /etc/apt/sources.list
RUN echo "deb [arch=amd64] http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse" >> /etc/apt/sources.list; \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 871920D1991BC93C; \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32; \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone; \
    apt-get update && apt-get install --no-install-recommends -y \
    librdkafka1 \
    build-essential \
    cmake \
    cron \
    git \
    gdb \
    gpg \
    jq \
    tar \
    vim \
    tcpdump \
    netcat \
    python3 \
    python3-pip \
    wget \
    libzstd-dev \
    libgoogle-perftools-dev && rm -rf /var/lib/apt/lists/*;

ENV ZSTD_LIB_DIR=/usr/lib/x86_64-linux-gnu

# Get Rust
COPY rust_install.sh /tmp/rust_install.sh
RUN bash -c "/tmp/rust_install.sh ${RUST_VERSION}"

COPY --from=build /tonlabs/ton-node/target/release/ton_node /ton-node/
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
