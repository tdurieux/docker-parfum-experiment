FROM archlinux:20200908
ARG packages

RUN echo "Server=https://archive.archlinux.org/repos/2020/09/08/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
RUN echo "[realtime]" >> /etc/pacman.d/mirrorlist
RUN echo "Server = https://pkgbuild.com/~dvzrv/repos/realtime/\$arch" >> /etc/pacman.d/mirrorlist

RUN pacman --noconfirm -Syyuu
RUN pacman --noconfirm -Syy
RUN pacman --noconfirm -S ${packages}