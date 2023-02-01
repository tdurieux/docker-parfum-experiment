FROM rust:1.51.0-slim as base
RUN apt -qq update -y && apt -qq --no-install-recommends install -y \
    gcc-mips-linux-gnu \
    libexpat1 \
    libmagic1 \
    libmpdec2 \
    libreadline7 \
    qemu-user && rm -rf /var/lib/apt/lists/*;
RUN rustup target add mips-unknown-linux-gnu
WORKDIR /code
ADD . .
RUN cp flatc_debian_stretch flatc
WORKDIR /code/tests
RUN rustc --version
RUN ./RustTest.sh mips-unknown-linux-gnu
