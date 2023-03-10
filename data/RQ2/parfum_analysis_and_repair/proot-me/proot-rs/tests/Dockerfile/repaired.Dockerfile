FROM proot/proot-rs-sdk:latest

RUN /bin/bash /usr/src/proot-rs/scripts/mkrootfs.sh -d /rootfs
ENV PROOT_TEST_ROOTFS="/rootfs"

CMD ["cargo", "make", "integration-test"]