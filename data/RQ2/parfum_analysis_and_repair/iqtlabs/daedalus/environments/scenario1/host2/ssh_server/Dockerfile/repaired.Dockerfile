FROM panubo/sshd
RUN apk add --no-cache sudo nfs-utils
RUN echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel
