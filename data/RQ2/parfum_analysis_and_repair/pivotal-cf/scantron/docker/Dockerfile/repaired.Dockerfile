FROM debian:jessie-slim

RUN apt-get update && apt-get install --no-install-recommends -y sqlite3 openssh-client && rm -rf /var/lib/apt/lists/*;
