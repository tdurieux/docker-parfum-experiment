FROM ubuntu:20.04 as halide-runtime

WORKDIR /halide

RUN set -eux && \
  apt update && \
  apt install --no-install-recommends -y wget clang g++ binutils libpng-dev libjpeg-dev && \
  wget https://github.com/halide/Halide/releases/download/v14.0.0/Halide-14.0.0-x86-64-linux-6b9ed2afd1d6d0badf04986602c943e287d44e46.tar.gz && \
  tar xzf Halide-14.0.0-x86-64-linux-6b9ed2afd1d6d0badf04986602c943e287d44e46.tar.gz && \
  rm Halide-14.0.0-x86-64-linux-6b9ed2afd1d6d0badf04986602c943e287d44e46.tar.gz && \
  mv Halide-14.0.0-x86-64-linux Halide-Runtime && rm -rf /var/lib/apt/lists/*;

COPY docker-entrypoint.generator.sh /usr/local/bin/docker-entrypoint.generator.sh
ENTRYPOINT [ "docker-entrypoint.generator.sh" ]
