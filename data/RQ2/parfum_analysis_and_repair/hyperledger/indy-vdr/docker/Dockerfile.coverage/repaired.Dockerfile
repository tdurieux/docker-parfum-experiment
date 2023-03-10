# syntax = docker/dockerfile:1.0-experimental

FROM rust:1.41-slim

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    	build-essential cmake lcov && \
    rm -rf /var/lib/apt/lists/*

RUN rustup default nightly

RUN --mount=type=cache,target=/usr/local/cargo/registry \
	cargo install grcov

WORKDIR /volume

RUN mkdir .cargo coverage libindy_vdr indy-vdr-proxy

COPY Cargo.toml Cargo.lock docker/rustc-add-coverage.sh ./
COPY indy-vdr-proxy/Cargo.toml indy-vdr-proxy/
COPY libindy_vdr/Cargo.toml libindy_vdr/

RUN cargo vendor > .cargo/config

# mount /volume/libindy_vdr, /volume/indy-vdr-proxy, /volume/coverage here
# mount /volume/target to cache build artifacts

ENV COVERAGE_CRATES ${COVERAGE_CRATES:-indy_vdr}
ENV COVERAGE_OPTIONS -Zprofile -Ccodegen-units=1 -Cinline-threshold=0 -Clink-dead-code -Coverflow-checks=off -Zno-landing-pads
ENV CARGO_INCREMENTAL 0
ENV RUSTC_WRAPPER ./rustc-add-coverage.sh
ENV WRAPPER_DEBUG ${WRAPPER_DEBUG:-}

CMD find target \( -name "*.gcda" -o -name "*.gcno" \) -exec rm {} \; && \
	cargo clean -p indy-vdr && \
	cargo test --lib --all-features --no-fail-fast && \
	find target \( -name "*.gcda" -o -name "*.gcno" \) -print && \
	grcov target \
		--branch --llvm --ignore-not-existing \
		--ignore "vendor/*" \
		--prefix-dir /volume/ \
		-t lcov -o coverage/lcov.info && \
	mkdir coverage/report && \
	genhtml -o coverage/report --show-details --highlight --ignore-errors source --legend coverage/lcov.info