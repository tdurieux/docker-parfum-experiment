FROM debian:stable

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    fakeroot && rm -rf /var/lib/apt/lists/*;
