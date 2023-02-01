FROM archlinux:latest

ARG BRANCH=master

COPY PKGBUILD /tmp/PKGBUILD

RUN pacman -Syu --noconfirm ; \
    pacman -S gcc git clang cmake pkg-config libgcrypt fakeroot sudo --noconfirm ; \
    pacman -S base-devel --noconfirm

RUN useradd -m -G wheel -s /bin/bash test ; \
    cp /tmp/PKGBUILD /home/test/ && chown test:test /home/test/PKGBUILD ; \
    sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

USER test
RUN cd /home/test && makepkg

USER root
RUN pacman -U /home/test/*zst --noconfirm

USER test
RUN yay -S criterion --noconfirm 

USER root
RUN git clone https://github.com/paolostivanin/libbaseencode -b $BRANCH ; \
    cd libbaseencode ; \
    mkdir build && cd $_ ; \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_TESTING=ON ; \
    make -j2 ;\
    ./tests/test_all ;\
    make install

