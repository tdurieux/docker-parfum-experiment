FROM debian:11

RUN apt-get update && apt-get install --no-install-recommends -y shellcheck && rm -rf /var/lib/apt/lists/*;
