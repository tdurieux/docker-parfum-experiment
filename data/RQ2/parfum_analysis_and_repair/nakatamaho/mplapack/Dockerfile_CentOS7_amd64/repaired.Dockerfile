FROM centos:7.9.2009
RUN yum install -y https://repo.ius.io/ius-release-el7.rpm && rm -rf /var/cache/yum
RUN yum install -y centos-release-scl && rm -rf /var/cache/yum
RUN yum install -y devtoolset-9 && rm -rf /var/cache/yum
RUN scl enable devtoolset-9 bash
RUN yum install -y gcc gcc-c++ gcc-gfortran make automake libtool && rm -rf /var/cache/yum
RUN yum install -y python3 && rm -rf /var/cache/yum
RUN yum install -y sudo which patch bzip2 git wget time && rm -rf /var/cache/yum
RUN yum install -y emacs && rm -rf /var/cache/yum

ARG DOCKER_UID=1000
ARG DOCKER_USER=docker
ARG DOCKER_PASSWORD=docker
RUN useradd -u $DOCKER_UID -m $DOCKER_USER --shell /bin/bash -G wheel,root && \
    echo "$DOCKER_USER:$DOCKER_PASSWD" | chpasswd && \
    echo "$DOCKER_USER ALL=(ALL) ALL" >> /etc/sudoers && \
    echo "$DOCKER_USER ALL=NOPASSWD: ALL" >> /etc/sudoers

ARG GIT_EMAIL="maho.nakata@gmail.com"
ARG GIT_NAME="NAKATA Maho"

USER ${DOCKER_USER}
RUN echo "[user]" >> /home/$DOCKER_USER/.gitconfig && \
    echo "email = ${GIT_EMAIL}" >> /home/$DOCKER_USER/.gitconfig && \
    echo "name = ${GIT_NAME}" >> /home/$DOCKER_USER/.gitconfig

RUN cd /home/$DOCKER_USER && echo "cd /home/$DOCKER_USER" >> .bashrc
RUN cd /home/$DOCKER_USER && wget https://github.com/nakatamaho/mplapack/releases/download/v1.9.9/mplapack-2.0.0-alpha.tar.xz
RUN cd /home/$DOCKER_USER && tar xvfJ mplapack-2.0.0-alpha.tar.xz && rm mplapack-2.0.0-alpha.tar.xz
RUN cd /home/$DOCKER_USER/mplapack-2.0.0
ARG CXX="/opt/rh/devtoolset-9/root/usr/bin/g++"
ARG CC="/opt/rh/devtoolset-9/root/usr/bin/gcc"
ARG FC="/opt/rh/devtoolset-9/root/usr/bin/gfortran"
RUN cd /home/$DOCKER_USER/mplapack-2.0.0 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=$HOME/MPLAPACK --enable-gmp=yes --enable-mpfr=yes --enable-_Float128=yes --e\nable-qd=yes --enable-dd=yes --enable-double=yes --enable-_Float64x=yes --enable-test=yes
RUN cd /home/$DOCKER_USER/mplapack-2.0.0 && make -j`getconf _NPROCESSORS_ONLN`
RUN cd /home/$DOCKER_USER/mplapack-2.0.0 && make install
