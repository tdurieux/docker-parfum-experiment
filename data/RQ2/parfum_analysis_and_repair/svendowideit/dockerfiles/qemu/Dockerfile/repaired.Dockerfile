# docker run --rm -it -v /mnt/sda6/sven/src/docker/boot2docker/boot2docker.iso:/boot2docker.iso --privileged qemu

FROM debian:jessie

RUN apt-get update \
	&& apt-get install --no-install-recommends -yq qemu-system-x86 qemu-utils && rm -rf /var/lib/apt/lists/*;


# qemu-system-x86_64 -curses -net nic -net user -m 2048M -boot d -cdrom ../../boot2docker/boot2docker.iso
CMD ["qemu-system-x86_64", "-curses", "-net", "nic", "-net", "user", "-m", "2048M", "-boot", "d", "-cdrom", "/boot2docker.iso"]
