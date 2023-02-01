FROM nvidia/cuda:10.2-devel-ubuntu18.04

# Install APT packages.
RUN apt-get update && \
        apt-get install --no-install-recommends -y build-essential cmake && rm -rf /var/lib/apt/lists/*;

COPY . /tensorpipe

WORKDIR /tensorpipe
