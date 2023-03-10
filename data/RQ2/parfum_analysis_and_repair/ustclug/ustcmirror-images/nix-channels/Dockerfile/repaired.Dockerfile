FROM ustcmirror/base:alpine

RUN \


    wget https://nixos.org/releases/nix/nix-2.3.2/nix-2.3.2-x86_64-linux.tar.xz -O /tmp/nix.tar.xz && \
    mkdir /tmp/nix.unpack && \
    tar xpf /tmp/nix.tar.xz -C /tmp/nix.unpack && \
    mkdir /nix && \
    cp -dpr /tmp/nix.unpack/*/store /nix/store && \
    ln -s /nix/store/*-nix-*/bin/* /usr/local/bin && \
    rm -rf /tmp/nix.tar.xz /tmp/nix.unpack && \
    # ca-certificates required by nix
    apk add --no-cache ca-certificates python3 py3-requests py3-pip py3-lxml py3-tz && \
    pip3 install --no-cache-dir pyquery minio==6.0.2

ADD [ "sync.sh", "nix-channels.py", "/" ]
