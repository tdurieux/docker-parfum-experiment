FROM rust:1.61-buster as builder

WORKDIR /build/mongoproxy

COPY Cargo.* ./
COPY proxy/ ./proxy
COPY mongo-protocol/ ./mongo-protocol
COPY async-bson/ ./async-bson

RUN cargo build

FROM debian:buster

RUN apt-get update
RUN apt-get install --no-install-recommends -y sudo procps sysstat net-tools curl netcat iptables less && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y heaptrack && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y valgrind && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y rust-gdb && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y iptables && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --set iptables /usr/sbin/iptables-legacy

RUN adduser --uid 9999 --disabled-password --gecos '' mongoproxy

RUN adduser mongoproxy sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR /mongoproxy
RUN chown mongoproxy:mongoproxy /mongoproxy

USER mongoproxy

COPY --from=builder /build/mongoproxy/target/debug/mongoproxy ./
COPY iptables-init.sh .
