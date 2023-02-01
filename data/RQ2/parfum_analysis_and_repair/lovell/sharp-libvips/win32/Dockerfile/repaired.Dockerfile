FROM debian:buster
LABEL maintainer="Lovell Fuller <npm@lovell.info>"

# Create Debian-based container suitable for post-processing Windows binaries

RUN apt-get update && apt-get install --no-install-recommends -y advancecomp brotli curl zip && rm -rf /var/lib/apt/lists/*;
