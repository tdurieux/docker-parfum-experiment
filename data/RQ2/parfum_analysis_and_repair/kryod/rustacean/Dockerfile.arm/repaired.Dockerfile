FROM arm32v7/rust:1.33.0-slim

RUN mkdir -p /usr/share/man/man1

RUN apt-get update -y && apt-get install --no-install-recommends -y \
    pkg-config \
    libsqlite3-dev \
    python3 \
    g++ \
    nodejs \
    php-cli \
    mono-devel \
    mono-vbnc \
    lua5.3 \
    lua-socket \
    lua-sec \
    openjdk-8-jdk \
    nasm \
    ruby-full && rm -rf /var/lib/apt/lists/*;

RUN cargo install diesel_cli --no-default-features --features "sqlite"

RUN apt-get install --no-install-recommends -y wget unzip && \
    cd /usr/lib && \
    wget https://github.com/JetBrains/kotlin/releases/download/v1.3.20-eap-25/kotlin-compiler-1.3.20-eap-25.zip && \
    unzip kotlin-compiler-*.zip && \
    rm kotlin-compiler-*.zip && \
    rm -f kotlinc/bin/*.bat && \
    apt-get remove -y wget unzip && rm -rf /var/lib/apt/lists/*;

ENV PATH $PATH:/usr/lib/kotlinc/bin

COPY ./ /home

WORKDIR /home

RUN useradd -d /home --uid 1000 -s /bin/bash -p dev dev

ENV DOCKER_ENV=true

RUN cargo build --release

CMD ["cargo", "run", "--release"]