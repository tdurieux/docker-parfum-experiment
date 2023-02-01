FROM amd64/rust:latest

WORKDIR /app
COPY . /app
RUN ls /app

RUN cargo build --release

CMD ["cargo", "run"]