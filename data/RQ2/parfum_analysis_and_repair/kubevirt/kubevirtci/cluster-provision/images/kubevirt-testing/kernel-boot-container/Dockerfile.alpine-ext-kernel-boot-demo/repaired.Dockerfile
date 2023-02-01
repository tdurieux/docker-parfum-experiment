FROM alpine:latest
RUN apk update
RUN apk add --no-cache linux-virt
RUN apk add --no-cache openrc
RUN chown -R 107:107 /boot/initramfs-virt /boot/vmlinuz-virt

