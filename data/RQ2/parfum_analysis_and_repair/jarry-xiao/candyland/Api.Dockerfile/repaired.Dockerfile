FROM rust:1.60-bullseye AS chef
RUN cargo install cargo-chef
FROM chef AS planner
COPY das_api /rust/das_api/
WORKDIR /rust/das_api
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y build-essential make git && rm -rf /var/lib/apt/lists/*;
COPY lib /rust/lib
COPY contracts /rust/contracts
COPY plerkle /rust/plerkle
COPY deps /rust/deps
COPY plerkle_serialization /rust/plerkle_serialization
COPY digital_asset_types /rust/digital_asset_types
COPY messenger /rust/messenger
RUN mkdir -p /rust/das_api
WORKDIR /rust/das_api
COPY --from=planner /rust/das_api/recipe.json recipe.json
# Build dependencies - this is the caching Docker layer!
COPY das_api/Cargo.toml .
RUN cargo chef cook --release --recipe-path recipe.json
COPY das_api .
# Build application
RUN cargo build --release

FROM rust:1.61-slim-bullseye
ARG APP=/usr/src/app
RUN apt update \
    && apt install --no-install-recommends -y curl ca-certificates tzdata \
    && rm -rf /var/lib/apt/lists/*
ENV TZ=Etc/UTC \
    APP_USER=appuser
RUN groupadd $APP_USER \
    && useradd -g $APP_USER $APP_USER \
    && mkdir -p ${APP}
COPY --from=builder /rust/das_api/target/release/das_api ${APP}
RUN chown -R $APP_USER:$APP_USER ${APP}
USER $APP_USER
WORKDIR ${APP}
CMD /usr/src/app/das_api