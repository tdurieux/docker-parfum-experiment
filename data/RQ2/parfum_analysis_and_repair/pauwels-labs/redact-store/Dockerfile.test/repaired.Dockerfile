# Rust-based image with cargo-tarpaulin pre-installed
FROM xd009642/tarpaulin

# This build-arg will be used by cargo-tarpaulin to upload code coverage reports to coveralls
ARG REPO_TOKEN

# Perform apk actions as root
RUN apt install -y --no-install-recommends libssl-dev && rm -rf /var/lib/apt/lists/*;

# Create build directory as root
WORKDIR /usr/src
RUN USER=root cargo new service

# Perform an initial compilation to cache dependencies
WORKDIR /usr/src/service
COPY Cargo.lock Cargo.toml ./
RUN echo "fn main() {println!(\"if you see this, the image build failed and kept the depency-caching entrypoint. check your dockerfile and image build logs.\")}" > src/main.rs
RUN cargo tarpaulin --locked

# Load source code to create final binary
RUN rm -rf src
# If the bust file exists, it will be added
# If it's filled with a random value, the testing and code coverage
# cache will be broken
COPY src bust* ./src/
# Copy the fit folder so code cov knows which branch we're on
COPY .git .git
RUN cargo tarpaulin --locked --skip-clean --coveralls $REPO_TOKEN
