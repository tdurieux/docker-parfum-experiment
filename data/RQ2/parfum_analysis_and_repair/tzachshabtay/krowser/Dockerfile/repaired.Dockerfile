FROM ubuntu:18.04 as build

RUN apt-get update && apt-get install --no-install-recommends -y build-essential \
    curl \
    openssl libssl-dev \
    pkg-config \
    python \
    valgrind \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get update
RUN apt-get install --no-install-recommends -y ninja-build clang && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl unzip tar wget git && rm -rf /var/lib/apt/lists/*;
RUN apt-get autoremove -y
RUN wget -O cmake.sh https://github.com/Kitware/CMake/releases/download/v3.15.5/cmake-3.15.5-Linux-x86_64.sh && sh ./cmake.sh --prefix=/usr/local --skip-license


ENV CC clang
ENV CXX clang++

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH /root/.cargo/bin/:$PATH

# Create a new empty shell project
RUN USER=root cargo new --bin krowser
RUN echo "fn main() {}" > /krowser/main.rs
WORKDIR /krowser

# Copy our manifests
COPY ./src/server/Cargo.lock ./Cargo.lock
COPY ./src/server/Cargo.toml ./Cargo.toml

# Build only the dependencies to cache them
RUN cargo build --release --features=rdkafka/cmake_build
RUN rm ./*.rs

# Copy the source code
COPY ./src/server ./

# Build for release.
RUN rm ./target/release/deps/krowser*
RUN cargo build --release

FROM node:12.18.0-buster AS base
WORKDIR /usr/src/krowser
COPY package*.json ./
# Copy from the previous build
COPY --from=build /krowser/target/release/krowser /usr/src/krowser
RUN chmod +x /usr/src/krowser


FROM base AS dependencies
RUN npm i && npm cache clean --force;

FROM dependencies AS release
COPY . .
RUN npm run build:frontend
CMD ["/usr/src/krowser/krowser"]
