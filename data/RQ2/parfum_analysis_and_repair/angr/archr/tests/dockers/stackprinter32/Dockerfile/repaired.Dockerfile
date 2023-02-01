from ubuntu:focal
RUN dpkg --add-architecture i386 && apt update && apt install --no-install-recommends -y libc6:i386 -o APT::Immediate-Configure=0 && rm -rf /var/lib/apt/lists/*;
copy stackprinter /
entrypoint [ "/stackprinter", "AAAAAAAA", "BBBBBBBBB" ]
