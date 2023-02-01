FROM alpine:3.15
RUN mkdir -p /lib/apk/db /run

# Simple service management system
RUN apk add --initdb openrc
# Kernel files
RUN apk add linux-virt dbus-libs kbd-bkeymaps

# Basic files needed for initramfs runtime
RUN apk add --update alpine-baselayout alpine-conf alpine-keys busybox busybox-initscripts rng-tools util-linux

# Copy kernel for later use
RUN cp /boot/vmlinuz-virt /vmlinuz
RUN cp /boot/*con* /config

# Cleanup
RUN rm -rf /boot
RUN rm -rf /var/cache/apk/*

# Automatic login for root on terminal
RUN echo "tty0::respawn:/sbin/agetty -a root -L tty0 38400 linux" >> /etc/inittab
RUN echo "hvc0::respawn:/sbin/agetty -a root -L hvc0 38400 linux" >> /etc/inittab
RUN echo "Welcome to initramfs" > /etc/motd

# Our init
COPY simple_init /init