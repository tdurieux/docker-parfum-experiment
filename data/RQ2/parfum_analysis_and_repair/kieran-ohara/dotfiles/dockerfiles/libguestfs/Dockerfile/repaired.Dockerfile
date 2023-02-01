FROM debian:buster-slim

RUN apt-get update -y && apt-get install --no-install-recommends -y libguestfs-tools && rm -rf /var/lib/apt/lists/*;
