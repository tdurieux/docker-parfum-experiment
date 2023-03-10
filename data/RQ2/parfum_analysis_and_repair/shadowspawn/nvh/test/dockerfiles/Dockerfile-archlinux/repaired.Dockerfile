FROM pritunl/archlinux:latest

# archlinux is interesting because /usr/local/share/man is a link to /usr/local/man

# has curl in base image
RUN pacman -S --noconfirm rsync \
&& pacman -S --noconfirm wget

CMD ["/bin/bash"]