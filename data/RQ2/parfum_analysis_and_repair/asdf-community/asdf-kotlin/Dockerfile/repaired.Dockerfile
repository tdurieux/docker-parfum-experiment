FROM ubuntu:focal-20211006

RUN \
  apt update && \
  apt install --no-install-recommends -y git curl rsync unzip python3-pip && \
  pip3 install --no-cache-dir shyaml && \
  useradd --create-home --shell /bin/bash build && \
  mkdir -p /home/build/src && \
  chown build:build /home/build/src && rm -rf /var/lib/apt/lists/*;

USER build
WORKDIR /home/build/src
ENTRYPOINT ["/bin/bash", "-c"]
