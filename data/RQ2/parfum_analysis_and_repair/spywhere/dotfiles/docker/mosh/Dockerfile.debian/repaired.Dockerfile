FROM debian:bullseye-slim AS builder
WORKDIR /etc/app
RUN apt update
RUN apt install --no-install-recommends -y ca-certificates git debhelper autotools-dev protobuf-compiler libprotobuf-dev dh-autoreconf pkg-config libutempter-dev zlib1g-dev libncurses5-dev libssl-dev bash-completion locales && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/mobile-shell/mosh mosh
WORKDIR /etc/app/mosh
RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
RUN make install

FROM debian:bullseye-slim
RUN apt update
LABEL DEPS="apt install -y libncursesw5 libreadline7"
RUN apt install --no-install-recommends -y libncursesw5 libreadline7 && rm -rf /var/lib/apt/lists/*;
COPY --from=builder /usr/local/bin/mosh /usr/bin/mosh
LABEL BINARY="mosh"
LABEL TEST="--version"
CMD mosh
