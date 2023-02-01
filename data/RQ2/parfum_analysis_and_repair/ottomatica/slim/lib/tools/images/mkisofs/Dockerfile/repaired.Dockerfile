FROM ubuntu:20.04
RUN apt update && \
    apt install --no-install-recommends mkisofs e2fsprogs mtools dosfstools wget -y && \
    apt clean && rm -rf /var/lib/apt/lists/*;

RUN wget https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.gz
RUN tar -xvf syslinux-6.03.tar.gz && rm syslinux-6.03.tar.gz

RUN apt install --no-install-recommends grub-efi gdisk rsync -y && rm -rf /var/lib/apt/lists/*;

# syslinux-6.03/efi64/efi/syslinux.efi
# syslinux-6.03/efi64/com32/elflink/ldlinux/ldlinux.e64