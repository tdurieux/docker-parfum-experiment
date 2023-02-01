FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        clang \
        llvm \
        scons && rm -rf /var/lib/apt/lists/*;

RUN useradd lilith
USER lilith
