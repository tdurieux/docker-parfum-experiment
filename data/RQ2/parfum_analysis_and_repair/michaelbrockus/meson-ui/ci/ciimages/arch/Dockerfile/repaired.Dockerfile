FROM archlinux:latest

ENV DEBIAN_FRONTEND noninteractive
ENV LANG='C.UTF-8'

# Use Native Package Manager
# Patch config files
RUN sed -i 's/#Color/Color/g'                            /etc/pacman.conf  &&\
    sed -i 's,#MAKEFLAGS="-j2",MAKEFLAGS="-j$(nproc)",g' /etc/makepkg.conf &&\
    sed -i "s,PKGEXT='.pkg.tar.xz',PKGEXT='.pkg.tar',g"  /etc/makepkg.conf

RUN pacman -Syu --needed --noprogressbar --noconfirm python python-setuptools python-wheel python-pip

# Add Python Scripts
ADD install.py .

# Run Python Scripts
RUN python3 install.py