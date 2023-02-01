FROM debian:bullseye-slim AS builder
WORKDIR /etc/app
RUN apt update
RUN apt install --no-install-recommends -y ca-certificates git automake gcc make libncursesw5-dev libreadline-dev pkg-config && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/dvorka/hstr hstr
WORKDIR /etc/app/hstr/build/tarball
RUN ./tarball-automake.sh
WORKDIR /etc/app/hstr
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
RUN make install

FROM debian:bullseye-slim
RUN apt update
LABEL DEPS="apt install -y libncursesw5 libreadline7"
RUN apt install --no-install-recommends -y libncursesw5 libreadline7 && rm -rf /var/lib/apt/lists/*;
COPY --from=builder /usr/local/bin/hstr /usr/bin/hstr
LABEL BINARY="hstr"
LABEL TEST="--version"
CMD hstr
