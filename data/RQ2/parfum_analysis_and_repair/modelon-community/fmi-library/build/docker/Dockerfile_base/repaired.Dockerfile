FROM ubuntu:16.04

# 'language-pack-sv' is needed for locale tests
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    cmake \
    doxygen \
    vim \
    language-pack-sv && rm -rf /var/lib/apt/lists/*;
