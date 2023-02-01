ARG BASE_IMAGE=ubuntu:latest
FROM $BASE_IMAGE

RUN mkdir /TFetch
ADD ./** /TFetch/.
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
    git \
    curl \
    neovim \
    build-essential && rm -rf /var/lib/apt/lists/*;