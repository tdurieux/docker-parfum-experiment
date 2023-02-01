
# docker run --rm -it -v /mnt/sda6/sven/src/docker/boot2docker/boot2docker.iso:/boot2docker.iso --privileged qemu

FROM debian:jessie

RUN apt-get update \
	&& apt-get install -yq qemu-system-x86 qemu-utils 


# qemu-system-x86_64 -curses -net nic -net user -m 2048M -boot d -cdrom ../../boot2docker/boot2docker.iso
CMD ["qemu-system-x86_64", "-curses", "-net", "nic", "-net", "user", "-m", "2048M", "-boot", "d", "-cdrom", "/boot2docker.iso"]
