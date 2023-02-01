FROM ubuntu:16.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y git clang-format-6.0 && rm -rf /var/lib/apt/lists/*;

# Copy freedom-metal into container
RUN mkdir freedom-metal
COPY ./ freedom-metal/

WORKDIR ./freedom-metal
