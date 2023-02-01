FROM debian:wheezy

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && apt-get -y --no-install-recommends install openssh-client coreutils fakeroot build-essential kernel-package wget xz-utils gnupg bc devscripts apt-utils initramfs-tools aria2 curl && apt-get clean && rm -rf /var/lib/apt/lists/*;
