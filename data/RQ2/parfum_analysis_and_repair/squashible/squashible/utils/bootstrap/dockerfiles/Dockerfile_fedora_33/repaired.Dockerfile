FROM fedora:33

# Add a directory to hold our chroot
RUN mkdir /tmp/bootstrap

# Build the chroot as soon as the docker container starts
CMD ["dnf", "install", "-y", "--installroot=/tmp/bootstrap", "--releasever=33", "--nogpg", "systemd", "passwd", "yum", "fedora-release", "vim-minimal", "openssh-server", "procps-ng","grubby"]