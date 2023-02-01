# Install build packages

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get -y install --assume-yes --no-install-recommends \
    ^G++^ \
    ^LIBC^ && rm -rf /var/lib/apt/lists/*;
