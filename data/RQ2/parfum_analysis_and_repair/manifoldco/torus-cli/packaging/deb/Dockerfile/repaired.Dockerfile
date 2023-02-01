FROM ubuntu:16.10

RUN apt-get update && \
	apt-get install --no-install-recommends -y reprepro && \
	apt-get clean && rm -rf /var/lib/apt/lists/*;

VOLUME torus
