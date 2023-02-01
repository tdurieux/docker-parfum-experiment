FROM redhat/ubi8

RUN dnf install openssl-devel gcc -y
RUN curl -f -sSL sh.rustup.rs >/tmp/rustup.sh && bash /tmp/rustup.sh -y
ENV PATH=${PATH}:${HOME}/.cargo/bin
RUN . /root/.cargo/env && cargo install cargo-generate-rpm
