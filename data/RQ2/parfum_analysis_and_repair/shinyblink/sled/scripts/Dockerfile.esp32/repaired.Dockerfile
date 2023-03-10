FROM archlinux/base

RUN pacman -Sy
RUN pacman -Syyu --noconfirm
RUN pacman -S --noconfirm git sudo binutils coreutils python2 python2-pip tar file awk fakeroot make 
RUN useradd -m build
RUN echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER build
WORKDIR /home/build
RUN git clone https://aur.archlinux.org/python-click-5.1.git
RUN git clone https://aur.archlinux.org/platformio.git

RUN cd python-click-5.1 && makepkg -si --noconfirm
RUN cd platformio && makepkg -si --noconfirm

RUN pio platform install espressif32 --with-package framework-arduinoespressif32

WORKDIR /home/build/sled
CMD make -j8 libsled.a