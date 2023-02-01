FROM debian:jessie-slim
RUN apt-get update
RUN apt-get -y --no-install-recommends install build-essential bc && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install openssl && rm -rf /var/lib/apt/lists/*;
