ARG PREFIX=
FROM ${PREFIX}ubuntu:bionic
RUN apt-get update && apt-get install --no-install-recommends -y \
  gcc musl musl-tools musl-dev git-core file && rm -rf /var/lib/apt/lists/*;
WORKDIR /tmp
CMD setarch $arch ./release
