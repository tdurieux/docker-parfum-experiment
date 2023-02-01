FROM ubuntu:20.04
COPY ./build/exchange /app/exchange

RUN apt-get update && apt-get -y --no-install-recommends install libpqxx-6.4 libprotobuf17 && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/app/exchange"]