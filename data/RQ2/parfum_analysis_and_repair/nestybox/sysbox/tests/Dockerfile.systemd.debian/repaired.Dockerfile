ARG sys_arch
FROM sysbox-test-${sys_arch}:latest

#
# Systemd installation
#
RUN apt-get update &&                            \
    apt-get install -y --no-install-recommends   \
            systemd                              \
            systemd-sysv                         \
            libsystemd0                          \
            ca-certificates                      \
            dbus                                 \
            iptables                             \
            iproute2                             \
            kmod                                 \
            locales                              \
            sudo                                 \
            udev &&                              \
                                                 \
    # Prevents journald from reading kernel messages from /dev/kmsg
    echo "ReadKMsg=no" >> /etc/systemd/journald.conf &&               \
                                                                      \
    # Disabling getty services to deal with a known-issue that allows
    # systemd's getty daemon to hog the host CPU when running inside
    # 'privileged' containers.
    systemctl mask getty@tty1.service getty-static.service &&         \
                                                                      \
    # Housekeeping
    apt-get clean -y &&                                               \
    rm -rf                                                            \
       /var/cache/debconf/*                                           \
       /var/lib/apt/lists/*                                           \
       /var/log/*                                                     \
       /tmp/*                                                         \
       /var/tmp/*                                                     \
       /usr/share/doc/*                                               \
       /usr/share/man/*                                               \
       /usr/share/local/* &&                                          \
                                                                      \
    # Create default 'admin/admin' user
    useradd --create-home --shell /bin/bash admin && echo "admin:admin" | \
        chpasswd && adduser admin sudo

# The sysbox installer will look for the linux-headers
RUN apt-get update && apt-get install -y --no-install-recommends \
            linux-headers-amd64 && rm -rf /var/lib/apt/lists/*;

# Make use of stopsignal (instead of sigterm) to stop systemd containers.
STOPSIGNAL SIGRTMIN+3

# Allow systemd to identify the virtualization mode to operate on (docker mode).
ENV container docker

# Set systemd as entrypoint.
ENTRYPOINT [ "/sbin/init" ]
