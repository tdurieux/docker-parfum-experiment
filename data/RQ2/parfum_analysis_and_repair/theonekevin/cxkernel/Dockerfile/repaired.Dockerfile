FROM gitpod/workspace-full:latest
USER root
RUN apt-get update && \
    apt-get install --no-install-recommends -y nasm xorriso quilt minicom && \
    apt-get install --no-install-recommends -y qemu qemu-kvm && \
    apt-get install --no-install-recommends -y grub-pc grub-pc-bin grub-rescue-pc && rm -rf /var/lib/apt/lists/*;
