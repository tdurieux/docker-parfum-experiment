FROM debian:buster

RUN apt-get update && apt-get install --no-install-recommends --yes debootstrap && rm -rf /var/lib/apt/lists/*;

# Run debootstrap to bootstrap a minimal debian install in a directory
RUN debootstrap --variant=minbase buster outdir

# Create an empty image, and copy those files into it
FROM scratch 
COPY --from=0 /outdir .

# We're now in the base image, and we can install additional packages etc.
# TODO: Move into debootstrap?
# TODO: Try --no-install-recommends everywhere?


# Install kernel
RUN apt-get -y update
RUN apt-get -y install --no-install-recommends linux-image-amd64 && rm -rf /var/lib/apt/lists/*;


# systemd-sysv makes systemd the init process
RUN apt-get -y install --no-install-recommends systemd-sysv && rm -rf /var/lib/apt/lists/*;


# Install and configure grub as our bootloader
# noninteractive to avoid prompts because we aren't actually installing to a disk yet
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install --yes grub-pc && rm -rf /var/lib/apt/lists/*;
ADD grub /etc/default/grub


# Install a basic fstab for filesystem mounting
ADD fstab /etc/fstab


# iproute2 is important for networking
RUN apt-get install --no-install-recommends --yes iproute2 && rm -rf /var/lib/apt/lists/*;


# We need DHCP to get IPs in most environments
RUN apt-get install --no-install-recommends --yes isc-dhcp-client && rm -rf /var/lib/apt/lists/*;


# Create locales: en_US.UTF-8
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install --yes locales && rm -rf /var/lib/apt/lists/*;
RUN sed -i -e "s/# en_US.UTF-8/en_US.UTF-8/g" /etc/locale.gen
RUN locale-gen
RUN update-locale LANG=en_US.UTF-8


# Ensure timezone is configured as UTC
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime


# Enable DHCP on all interfaces
ADD en-wildcard.network /etc/systemd/network/en-wildcard.network
# Must be readable by systemd-networkd at least
#  https://bbs.archlinux.org/viewtopic.php?id=239036
RUN chmod 0644 /etc/systemd/network/en-wildcard.network


# For reasons not entirely clear, systemd-networkd is not enabled by default,
# but without it network interfaces don't seem to come up
RUN systemctl enable systemd-networkd


# Don't try to resume from swap.
# TODO: Can we do this step as part of the kernel install?
RUN echo "RESUME=none" > /etc/initramfs-tools/conf.d/resume
RUN update-initramfs -u


# Make sure SSH server is installed.
RUN apt-get install --no-install-recommends --yes openssh-server && rm -rf /var/lib/apt/lists/*;
# Remove any ssh host keys that may have been generated
RUN rm -f /etc/ssh/ssh_host_*_key /etc/ssh/ssh_host_*_key.pub


# Ensure sudo is installed
RUN apt-get install --no-install-recommends --yes sudo && rm -rf /var/lib/apt/lists/*;


# Enable DNS with systemd-resolved
RUN systemctl enable systemd-resolved


# Ensure iptables is installed
RUN apt-get install --no-install-recommends --yes iptables && rm -rf /var/lib/apt/lists/*;
