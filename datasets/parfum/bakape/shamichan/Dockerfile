# Built using `make dockerfiles`. DO NOT EDIT!

# TODO: separate server image from imager image
# TODO: coverage report in the CI
FROM ubuntu:focal

EXPOSE 8000

RUN mkdir -p /shamichan/images /shamichan/www/videos /src
WORKDIR /shamichan
CMD ["-a", ":8000"]
ENTRYPOINT ["./shamichan"]

# Install OS dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y \
	build-essential \
	pkg-config \
	libopencv-dev \
	libgeoip-dev \
	git wget curl \
	postgresql-client \
	libssl-dev \
	&& apt-get clean
RUN apt-get dist-upgrade -y && apt-get clean

# Install Node.js
RUN wget -q -O- https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs && apt-get clean

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH=$PATH:/root/.cargo/bin

# Build WASM build tools
RUN cargo install wasm-pack

# Install Go
RUN wget -O- \
	"https://dl.google.com/go/$(curl https://go.dev/VERSION?m=text).linux-amd64.tar.gz" \
	| tar xpz -C /usr/local
ENV PATH=$PATH:/usr/local/go/bin

# Install Go build tools
RUN go get -u github.com/valyala/quicktemplate \
	github.com/rakyll/statik \
	github.com/valyala/quicktemplate/qtc

# Download go deps
COPY go.mod go.sum ./
RUN go mod download

# Cache Node.js deps
COPY package.json package-lock.json ./
RUN npm install --progress false --depth 0
COPY client/package-lock.json client/package.json client/
RUN cd client && npm install --progress false --depth 0

# Cache Rust dependencies by faking a project structure
RUN mkdir -p \
	client/js client/src www/client \
	server/src \
	common/src
COPY Cargo.toml Cargo.lock ./
COPY client/Cargo.toml client/webpack.config.js client/
COPY client/js client/js
COPY docker/dummy.rs client/src/lib.rs
COPY server/Cargo.toml server
COPY docker/dummy.rs server/src/lib.rs
COPY common/Cargo.toml common
COPY docker/dummy.rs common/src/lib.rs

# Build deps for both prod and dev builds
RUN cargo build --workspace --exclude client --release
RUN cargo build --workspace --exclude client
RUN cd client && ./node_modules/.bin/webpack
RUN cd client && ./node_modules/.bin/webpack -d

# Remove dummy sources and artefacts
RUN rm -r \
	client/src server/src common/src \
	target/release/deps/libcommon* \
	target/debug/deps/libcommon* \
	target/wasm32-unknown-unknown/release/deps/libcommon* \
	target/wasm32-unknown-unknown/debug/deps/libcommon* \
	client/dist client/pkg

# Copy all sources
COPY . .



RUN NO_DEPS=1 make

################################################################################

FROM ubuntu:focal

RUN mkdir -p /shamichan/images /shamichan/www/videos
WORKDIR /shamichan
CMD ["-a", ":8000"]
ENTRYPOINT ["./shamichan"]

# Install OS dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y \
	libopencv-dev \
	libgeoip-dev \
	libssl-dev && \
	apt-get clean
RUN apt-get dist-upgrade -y && apt-get clean

# Copy compiled files from dev image
COPY --from=0 /shamichan/shamichan /shamichan/shamichan
COPY --from=0 /shamichan/www /shamichan/www
