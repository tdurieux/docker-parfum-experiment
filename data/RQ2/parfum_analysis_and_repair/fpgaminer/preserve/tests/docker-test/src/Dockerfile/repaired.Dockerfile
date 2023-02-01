FROM rust:latest

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y --no-install-recommends install ca-certificates libsqlite3-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir /backup
RUN mkdir /restore

WORKDIR /preserve

ADD create-backup.sh ./
ADD restore-backup.sh ./
ADD preserve-src ./

RUN cargo build --release
RUN cp target/release/preserve ./