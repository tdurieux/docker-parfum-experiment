FROM debian:10

RUN apt-get update && apt-get install --no-install-recommends -y xz-utils libcap2-bin jq && rm -rf /var/lib/apt/lists/*;

#RUN apt-get install -y strace procps elfutils gdb binutils vim patchelf

COPY fastfreeze.tar.xz /tmp

RUN set -ex; \
  tar xf /tmp/fastfreeze.tar.xz -C /opt; rm /tmp/fastfreeze.tar.xz \
  ln -s /opt/fastfreeze/fastfreeze /usr/local/bin/; \
  fastfreeze install

WORKDIR /opt/fastfreeze
