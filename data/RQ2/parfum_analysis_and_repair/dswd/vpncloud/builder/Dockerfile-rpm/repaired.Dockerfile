FROM centos:7

ARG TOOLCHAIN=stable

RUN yum groupinstall -y 'Development Tools'
RUN yum install -y ruby && gem install asciidoctor -v 2.0.10 && rm -rf /var/cache/yum

ENV RUSTUP_HOME=/opt/rust/rustup \
    PATH=/opt/rust/cargo/bin:/home/user/.cargo/bin:/usr/local/musl/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN curl https://sh.rustup.rs -sSf | env CARGO_HOME=/opt/rust/cargo sh -s -- -y --default-toolchain ${TOOLCHAIN} --profile minimal --no-modify-path

RUN env CARGO_HOME=/opt/rust/cargo rustup target add i686-unknown-linux-gnu \
 && env CARGO_HOME=/opt/rust/cargo rustup target add armv7-unknown-linux-gnueabihf

RUN env CARGO_HOME=/opt/rust/cargo cargo install cargo-rpm \
 && rm -rf /opt/rust/cargo/{git,tmp,registry}

RUN yum install -y libstdc++-*.i686 \
 && yum install -y glibc-*.i686 \
 && yum install -y libgcc.i686 && rm -rf /var/cache/yum

RUN ln -s /usr/bin/gcc /usr/bin/i686-linux-gnu-gcc

RUN useradd -ms /bin/bash user
USER user
WORKDIR /home/user

RUN mkdir -p /home/user/.cargo \
 && ln -s /opt/rust/cargo/config /home/user/.cargo/config

VOLUME /home/user/.cargo/tmp
VOLUME /home/user/.cargo/git
VOLUME /home/user/.cargo/registry