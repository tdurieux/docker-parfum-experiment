FROM ubuntu:20.04
RUN apt-get update && \
    # kernel, hyper-v support, and other virtual tooling.
    apt-get install --no-install-recommends -y linux-virtual linux-cloud-tools-virtual linux-tools-virtual && rm -rf /var/lib/apt/lists/*;

RUN echo $' \n\
hv_blkvsc\n\
hv_utils\n\
hv_vmbus\n\
hv_sock\n\
hv_storvsc\n\
hv_netvsc\n' >> /etc/initramfs-tools/modules

# hv_balloon\n\
RUN update-initramfs -u

# Move for easier extraction.
RUN mv /boot/vmlinuz-* /vmlinuz
RUN mv /boot/initrd.img-* /initrd

# Needed for configuring server and setting up devices.
RUN apt install --no-install-recommends cloud-init udev kmod -y && rm -rf /var/lib/apt/lists/*;
# Quality of life:
RUN apt install --no-install-recommends openssh-server sudo -y && rm -rf /var/lib/apt/lists/*;
RUN apt clean