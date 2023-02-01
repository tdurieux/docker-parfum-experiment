FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
	make \
	sudo && rm -rf /var/lib/apt/lists/*;
