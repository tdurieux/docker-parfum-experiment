FROM alpine
# TODO: redo as cross platform, and without git etc :)

ARG VERSION
ARG KERNEL_VERSION
ENV VERSION=${VERSION}
ENV KERNEL_VERSION=${KERNEL_VERSION}

# not installed atm udev, grub2, kexe-tools
# parted: partprobe, e2fsprogs: mkfs.ext4, syslinux: extlinux&syslinux
# e2fsprogs-extra: chattr
RUN apk --no-cache add syslinux parted e2fsprogs e2fsprogs-extra util-linux

COPY conf /scripts/
COPY ./build/ros /bin/
#RUN cd /bin && ln -s ./ros ./system-docker
#OR softlink in the host one - this image should only be used when installing from ISO..
# (except its useful for testing)
# && ln -s /host/usr/bin/ros /bin/
COPY kexec/dist/sbin/kexec /sbin/

RUN ln -s /bootiso/boot/ /dist

COPY cache-services.sh /scripts/

# need to make a /scripts/set-disk-partitions so that older releases can call the installer
RUN echo "#!/bin/sh" > /scripts/set-disk-partitions \
    && echo "echo 'set-disk-partitions deprecated'" >> /scripts/set-disk-partitions \
    && chmod 755 /scripts/set-disk-partitions

# work around some really weird ros symptoms
RUN rm -rf /sbin/poweroff /sbin/shutdown /sbin/reboot /sbin/halt /usr/sbin/poweroff /usr/sbin/shutdown /usr/sbin/reboot /usr/sbin/halt

ENTRYPOINT ["/bin/ros", "install"]