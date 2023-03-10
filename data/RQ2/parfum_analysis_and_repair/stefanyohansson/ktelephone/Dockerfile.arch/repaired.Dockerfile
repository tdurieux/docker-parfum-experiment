FROM archlinux:latest
RUN echo '[alerque]' >> /etc/pacman.conf
RUN echo 'Server = https://arch.alerque.com/$arch' >> /etc/pacman.conf
RUN echo 'SigLevel = Never' >> /etc/pacman.conf
RUN pacman -Syyu --noconfirm
RUN pacman -S --noconfirm cmake pkgconf gcc make libconfig qt5-base qt5-multimedia pjproject bcg729
ADD . /usr/src/ktelephone
WORKDIR /usr/src/ktelephone
RUN mkdir -p build/
WORKDIR /usr/src/ktelephone/build
RUN CMAKE_C_COMPILER="/usr/bin/gcc" CMAKE_CXX_COMPILER="/usr/bin/g++" cmake ..
RUN make