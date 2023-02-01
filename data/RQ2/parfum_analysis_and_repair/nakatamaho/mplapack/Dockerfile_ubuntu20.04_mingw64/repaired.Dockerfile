FROM ubuntu:20.04

# change following two lines
ARG GIT_EMAIL="maho.nakata@gmail.com"
ARG GIT_NAME="NAKATA Maho"

RUN apt -y update
RUN apt -y upgrade
RUN apt install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;
# set your timezone
ENV TZ Asia/Tokyo
RUN echo "${TZ}" > /etc/timezone \
  && rm /etc/localtime \
  && ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
  && dpkg-reconfigure -f noninteractive tzdata

RUN apt install --no-install-recommends -y build-essential mingw-w64 gfortran-mingw-w64 python3 && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y autotools-dev automake libtool && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y git wget time && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y ng-common ng-cjk emacs-nox && rm -rf /var/lib/apt/lists/*;
RUN sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1

RUN dpkg --add-architecture i386
RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key
RUN mv winehq.key /usr/share/keyrings/winehq-archive.key
RUN wget -nc https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources
RUN mv winehq-focal.sources /etc/apt/sources.list.d/
RUN apt update -y
RUN apt install -y --install-recommends winehq-stable

ARG DOCKER_UID=1000
ARG DOCKER_USER=docker
ARG DOCKER_PASSWORD=docker
RUN useradd -u $DOCKER_UID -m $DOCKER_USER --shell /bin/bash && echo "$DOCKER_USER:$DOCKER_PASSWORD" | chpasswd && echo "$DOCKER_USER ALL=(ALL) ALL" >> /etc/sudoers
USER ${DOCKER_USER}
RUN echo "\n\
[user]\n\
        email = ${GIT_EMAIL}\n\
        name = ${GIT_NAME}\n\
" > /home/$DOCKER_USER/.gitconfig

RUN cd /home/$DOCKER_USER && echo "cd /home/$DOCKER_USER" >> .bashrc
RUN cd /home/$DOCKER_USER && echo "export WINEPATH=\"/usr/x86_64-w64-mingw32/lib/;/usr/lib/gcc/x86_64-w64-mingw32/9.3-win32/;/usr/lib/gcc/x86_64-w64-mingw32/9.3-posix;/home/$DOCKER_USER/MPLAPACK/bin\"" >> .bashrc

ARG WINEPATH="/usr/x86_64-w64-mingw32/lib/;/usr/lib/gcc/x86_64-w64-mingw32/9.3-win32/;/usr/lib/gcc/x86_64-w64-mingw32/9.3-posix"
ARG WINEDEBUG="-all"

RUN cd /home/$DOCKER_USER && echo "cd /home/$DOCKER_USER" >> .bashrc
RUN cd /home/$DOCKER_USER && wget https://github.com/nakatamaho/mplapack/releases/download/v1.9.9/mplapack-2.0.0-alpha.tar.xz
RUN cd /home/$DOCKER_USER && tar xvfJ mplapack-2.0.0-alpha.tar.xz && rm mplapack-2.0.0-alpha.tar.xz
RUN cd /home/$DOCKER_USER/mplapack-2.0.0
ARG CXX="x86_64-w64-mingw32-g++"
ARG CC="x86_64-w64-mingw32-gcc"
ARG FC="x86_64-w64-mingw32-gfortran"
ARG NM="x86_64-w64-mingw32-nm"
ARG RANLIB="x86_64-w64-mingw32-ranlib"
ARG AR="x86_64-w64-mingw32-ar"
RUN cd /home/$DOCKER_USER/mplapack-2.0.0 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=$HOME/MPLAPACK --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --enable-gmp=yes --enable-mpfr=yes --enable-_Float128=yes --enable-qd=yes --enable-dd=yes --enable-double=yes --enable-_Float64x=yes --enable-test=yes
RUN cd /home/$DOCKER_USER/mplapack-2.0.0 && make -j`getconf _NPROCESSORS_ONLN`
RUN cd /home/$DOCKER_USER/mplapack-2.0.0 && make install

