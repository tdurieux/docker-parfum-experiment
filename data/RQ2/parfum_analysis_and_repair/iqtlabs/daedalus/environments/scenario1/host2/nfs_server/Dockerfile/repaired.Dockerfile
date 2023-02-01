FROM erichough/nfs-server
RUN apk add --no-cache sudo
RUN echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel
