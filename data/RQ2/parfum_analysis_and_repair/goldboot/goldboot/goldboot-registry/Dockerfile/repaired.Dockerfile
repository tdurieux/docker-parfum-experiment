FROM debian

RUN apt-get install --no-install-recommends -y qemu-system-x86 ovmf && rm -rf /var/lib/apt/lists/*;