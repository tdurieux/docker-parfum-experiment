FROM debian:latest as builder

COPY . /app
WORKDIR /app
RUN apt-get update && apt-get -y upgrade && apt-get install --no-install-recommends -y libssl-dev build-essential && gcc src/*.c -lssl -lcrypto -o rdpscan && rm -rf /var/lib/apt/lists/*;

FROM gcr.io/distroless/cc
COPY --from=builder /app/rdpscan /app/rdpscan
ENTRYPOINT ["/app/rdpscan"]
