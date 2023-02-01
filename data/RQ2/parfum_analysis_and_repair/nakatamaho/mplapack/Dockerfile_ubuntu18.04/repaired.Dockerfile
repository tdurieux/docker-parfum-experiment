FROM ubuntu:18.04

# change following two lines
ARG GIT_EMAIL="maho.nakata@gmail.com"
ARG GIT_NAME="NAKATA Maho"

RUN apt update
RUN apt -y upgrade
RUN apt install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;
# set your timezone
ENV TZ Asia/Tokyo
RUN echo "${TZ}" > /etc/timezone \
  && rm /etc/localtime \
  && ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
  && dpkg-reconfigure -f noninteractive tzdata

RUN apt install --no-install-recommends -y build-essential gfortran python3 && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y autotools-dev automake libtool && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y git wget time && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y ng-common ng-cjk emacs-nox && rm -rf /var/lib/apt/lists/*;
RUN sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1

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
RUN cd /home/$DOCKER_USER && wget https://github.com/nakatamaho/mplapack/releases/download/v1.9.9/mplapack-2.0.0-alpha.tar.xz
RUN cd /home/$DOCKER_USER && tar xvfJ mplapack-2.0.0-alpha.tar.xz && rm mplapack-2.0.0-alpha.tar.xz
RUN cd /home/$DOCKER_USER/mplapack-2.0.0
ARG CXX="g++"
ARG CC="gcc"
ARG FC="gfortran"
RUN /bin/bash -c 'set -ex && \
    ARCH=`uname -m` && \
    if [ "$ARCH" == "x86_64" ]; then \
       cd /home/$DOCKER_USER/mplapack-2.0.0 && ./configure --prefix=$HOME/MPLAPACK --enable-gmp=yes --enable-mpfr=yes --enable-_Float128=yes --enable-qd=yes --enable-dd=yes --enable-double=yes --enable-_Float64x=yes --enable-test=yes; \
    else \
       cd /home/$DOCKER_USER/mplapack-2.0.0 && ./configure --prefix=$HOME/MPLAPACK --enable-gmp=yes --enable-mpfr=yes --enable-_Float128=yes --enable-qd=yes --enable-dd=yes --enable-double=yes --enable-test=yes ; \
    fi'
RUN cd /home/$DOCKER_USER/mplapack-2.0.0 && make -j`getconf _NPROCESSORS_ONLN`
RUN cd /home/$DOCKER_USER/mplapack-2.0.0 && make install
