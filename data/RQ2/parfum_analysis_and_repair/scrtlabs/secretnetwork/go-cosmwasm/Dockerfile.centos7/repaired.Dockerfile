FROM centos:centos7

RUN yum -y update
RUN yum -y install clang gcc gcc-c++ make wget && rm -rf /var/cache/yum

# GET FROM https://github.com/rust-lang/docker-rust-nightly
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH


RUN url="https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init"; \
    wget "$url"; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --default-toolchain nightly-2020-06-08; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;

# PRE-FETCH MANY DEPS
WORKDIR /scratch
COPY Cargo.toml /scratch/
COPY Cargo.lock /scratch/
COPY src /scratch/src
RUN cargo fetch
# allow non-root user to download more deps later
RUN chmod -R 777 /usr/local/cargo


## COPY BUILD SCRIPTS

WORKDIR /code
RUN rm -rf /scratch

COPY build/build_linux.sh /opt
RUN chmod +x /opt/build*

RUN mkdir /.cargo
RUN chmod +rx /.cargo
COPY build/cargo-config /.cargo/config

CMD ["/opt/build_linux.sh"]
