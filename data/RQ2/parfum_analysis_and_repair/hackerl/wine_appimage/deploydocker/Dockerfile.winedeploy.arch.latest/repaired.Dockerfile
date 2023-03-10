FROM archlinux/base

COPY . /srv/wineappimage

WORKDIR /srv/wineappimage

RUN patched_glibc=glibc-linux4-2.33-4-x86_64.pkg.tar.zst && curl -f -LO "https://repo.archlinuxcn.org/x86_64/$patched_glibc" && bsdtar -C / -xvf "$patched_glibc"
RUN /srv/wineappimage/deployscript/arch-winedeploy.sh