FROM ubuntu:18.04

RUN useradd -m avr-rust

# Install dependencies
RUN apt-get update -y && apt-get install --no-install-recommends -y wget gcc binutils gcc-avr avr-libc && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /code && chown avr-rust:avr-rust /code

USER avr-rust

# Install Rustup along with nightly
RUN wget -q https://sh.rustup.rs -O /tmp/rustup.sh && sh /tmp/rustup.sh -y --profile minimal --default-toolchain nightly -c rust-src --quiet
ENV PATH=/home/avr-rust/.cargo/bin:$PATH

COPY --chown=avr-rust:avr-rust . /code/delay

WORKDIR /code/delay

ENV AVR_CPU_FREQUENCY_HZ=16000000

CMD ["cargo", "build", "-Z", "build-std=core", "--target", "avr-unknown-gnu-atmega328", "--release"]
