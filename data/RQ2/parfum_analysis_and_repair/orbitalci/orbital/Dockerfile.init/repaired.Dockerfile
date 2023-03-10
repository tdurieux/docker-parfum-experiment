# Example: Build init file and runonce database migration
# docker build -t orbital-init -f Dockerfile.init .
# docker run -it --rm --net host orbital-init

FROM rust:1.39-slim
RUN apt update && apt install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN cargo install diesel_cli --no-default-features --features postgres

COPY ./models/orbital_database/postgres/migrations /migrations
ENV MIGRATION_DIRECTORY /migrations
ENV DATABASE_URL postgres://orbital:orbital@localhost:5432/orbital

CMD diesel migration run