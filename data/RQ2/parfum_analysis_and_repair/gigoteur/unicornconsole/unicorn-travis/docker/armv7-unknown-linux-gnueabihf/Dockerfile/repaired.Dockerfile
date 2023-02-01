FROM resin/rpi-raspbian

RUN apt-get update -q && apt-get install --no-install-recommends -y curl wget libreadline-dev libsdl2-dev python-dev python3-dev g++ gcc libc6 libc6-dev binutils git make file ca-certificates zip dpkg-dev && rm -rf /var/lib/apt/lists/*;

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH /root/.cargo/bin:$PATH

RUN git clone https://github.com/Gigoteur/UnicornConsole && cd UnicornConsole && cd unicorn && \
    cargo build --release
