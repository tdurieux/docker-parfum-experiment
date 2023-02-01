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

RUN apt install --no-install-recommends -y build-essential gfortran python3 && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y autotools-dev automake libtool && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y git wget time && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y ng-common ng-cjk emacs-nox && rm -rf /var/lib/apt/lists/*;
RUN sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
RUN wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
RUN apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
RUN echo "deb https://apt.repos.intel.com/oneapi all main" | sudo tee /etc/apt/sources.list.d/oneAPI.list
RUN apt update
RUN apt install --no-install-recommends -y intel-basekit && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y intel-hpckit && rm -rf /var/lib/apt/lists/*;

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

SHELL ["/bin/bash", "-c"]
RUN cd /home/$DOCKER_USER && echo "cd /home/$DOCKER_USER" >> .bashrc
RUN cd /home/$DOCKER_USER && echo "source /opt/intel/oneapi/setvars.sh" >> /home/$DOCKER_USER/.bashrc
RUN cd /home/$DOCKER_USER && wget https://github.com/nakatamaho/mplapack/releases/download/v1.9.9/mplapack-2.0.0-alpha.tar.xz
RUN cd /home/$DOCKER_USER && tar xvfJ mplapack-2.0.0-alpha.tar.xz && rm mplapack-2.0.0-alpha.tar.xz
ARG CXX="icpc"
ARG CC="icc"
ARG FC="ifort"
RUN cd /home/$DOCKER_USER && source /opt/intel/oneapi/setvars.sh && cd mplapack-2.0.0 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=$HOME/MPLAPACK --enable-gmp=yes --enable-mpfr=yes --enable-_Float128=yes --enable-qd=yes --enable-dd=yes --enable-double=yes --enable-_Float64x=yes --enable-test=yes
RUN cd /home/$DOCKER_USER/mplapack-2.0.0 && source /opt/intel/oneapi/setvars.sh && make -j`getconf _NPROCESSORS_ONLN`
RUN cd /home/$DOCKER_USER/mplapack-2.0.0 && source /opt/intel/oneapi/setvars.sh && make install
