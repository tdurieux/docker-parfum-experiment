FROM debian:buster-slim
WORKDIR /usr/app
RUN apt-get update && apt-get install --no-install-recommends -y pkg-config libssl-dev openssl && rm -rf /var/lib/apt/lists/*
COPY debug/rudr .
ENV RUST_LOG rudr=info
CMD ["./rudr"]