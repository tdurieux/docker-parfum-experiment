FROM archlinux/base

COPY . /srv/pcsx2appimage

WORKDIR /srv/pcsx2appimage
RUN /srv/pcsx2appimage/deployscript/archlinux-pcsx2-deploy.sh