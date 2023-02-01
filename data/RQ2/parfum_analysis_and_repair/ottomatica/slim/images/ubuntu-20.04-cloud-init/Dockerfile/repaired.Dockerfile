FROM ubuntu:20.04 AS kernel
RUN apt-get update && \
    apt-get install --no-install-recommends -y linux-virtual && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

FROM ubuntu:20.04

# Extract the kernel, modules, and initrd
COPY --from=kernel /lib/modules /lib/modules
COPY --from=kernel /boot/vmlinuz-* /vmlinuz
COPY --from=kernel /boot/initrd.img-* /initrd

RUN apt-get update
# Needed for configuring server and setting up devices.
RUN apt install --no-install-recommends cloud-init udev kmod -y && rm -rf /var/lib/apt/lists/*;
# If you'd like to be able to ssh in:
RUN apt install --no-install-recommends openssh-server sudo -y && rm -rf /var/lib/apt/lists/*;