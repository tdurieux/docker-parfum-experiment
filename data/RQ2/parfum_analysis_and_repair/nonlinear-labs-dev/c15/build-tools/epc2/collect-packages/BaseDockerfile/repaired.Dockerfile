FROM archlinux:20200908

RUN echo "Server = https://archive.archlinux.org/repos/2020/09/08/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist
RUN mkdir /packages
COPY linux-rt-@EPC2_BASE_KERNEL@-x86_64.pkg.tar.zst /packages/linux-rt-@EPC2_BASE_KERNEL@-x86_64.pkg.tar.zst
RUN repo-add -q /packages/rt.db.tar.gz /packages/linux-rt-@EPC2_BASE_KERNEL@-x86_64.pkg.tar.zst

RUN echo "[rt]" >> /etc/pacman.conf
RUN echo "SigLevel = Optional TrustAll" >> /etc/pacman.conf
RUN echo "Server=file:///packages/" >> /etc/pacman.conf

RUN sed "s/^\[core\]/[core]\nSigLevel = Optional TrustAll/g" -i /etc/pacman.conf
RUN sed "s/^\[extra\]/[extra]\nSigLevel = Optional TrustAll/g" -i /etc/pacman.conf
RUN sed "s/^\[community\]/[community]\nSigLevel = Optional TrustAll/g" -i /etc/pacman.conf

COPY collectPackages.sh /collectPackages.sh

RUN pacman --noconfirm -Sy
RUN pacman --noconfirm -S archlinux-keyring
RUN pacman --noconfirm -S pacman-contrib