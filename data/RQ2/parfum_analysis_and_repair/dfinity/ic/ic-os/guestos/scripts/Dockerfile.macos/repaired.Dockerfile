# 20.04
FROM ubuntu:focal-20211006

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y --no-install-recommends install \
      faketime \
      android-sdk-ext4-utils \
      dosfstools \
      fakeroot \
      mtools \
      policycoreutils \
      python3 && rm -rf /var/lib/apt/lists/*;

COPY . .
COPY bootloader.tar bootloader.tar
COPY rootfs.tar rootfs.tar

RUN scripts/build-disk-image.sh -o ic-os.img -t bootloader.tar -u rootfs.tar && \
    tar --sparse -czaf ic-os.img.tar ic-os.img && \
    rm ic-os.img && rm ic-os.img.tar
