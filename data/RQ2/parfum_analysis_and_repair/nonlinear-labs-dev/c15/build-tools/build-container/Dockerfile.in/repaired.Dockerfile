FROM archlinux:20200908
ARG packages
ARG tar
COPY ${tar} /packages/
RUN mkdir -p /extracted-packages
RUN cd /extracted-packages && tar -xzf /packages/${tar} && rm /packages/${tar}
RUN ls -la /extracted-packages/

RUN echo "" > /etc/pacman.d/mirrorlist

RUN sed -i 's/\[core\]//g' /etc/pacman.conf
RUN sed -i 's/\[extra\]//g' /etc/pacman.conf
RUN sed -i 's/\[community\]//g' /etc/pacman.conf
RUN echo "[nonlinux]" >> /etc/pacman.conf
RUN echo "SigLevel = Optional TrustAll" >> /etc/pacman.conf
RUN echo "Server=file:///extracted-packages" >> /etc/pacman.conf

RUN pacman --noconfirm -Syyuu
RUN pacman --noconfirm -Syy
RUN pacman --noconfirm -S ${packages}


