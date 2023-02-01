FROM gists/nfs-server
RUN apk add --no-cache bash sudo
RUN echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel
