FROM debian:bullseye-slim

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y grub-pc && rm -rf /var/lib/apt/lists/*;
