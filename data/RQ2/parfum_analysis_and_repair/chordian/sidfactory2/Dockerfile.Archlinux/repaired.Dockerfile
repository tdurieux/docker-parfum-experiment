FROM archlinux
WORKDIR /home
RUN pacman -Sy --noconfirm gcc make git sdl2
COPY . .
CMD ["make","dist"]