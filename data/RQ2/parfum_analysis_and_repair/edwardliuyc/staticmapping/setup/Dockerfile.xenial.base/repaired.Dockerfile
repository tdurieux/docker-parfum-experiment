# docker file for static mapping

FROM ros:kinetic-ros-core-xenial

LABEL author="edward" email="liuyongchuan@outook.com"

# COPY ./setup/tshinghua_source.xenial.txt /etc/apt/sources.list

# RUN sh -c '. /etc/lsb-release && echo "deb http://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu/ `lsb_release -cs` main" > /etc/apt/sources.list.d/ros1-latest.list'

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y --no-install-recommends install cmake gcc g++ libboost-all-dev libeigen3-dev libpng-dev libgoogle-glog-dev libatlas-base-dev \
  libsuitesparse-dev libpcl-dev wget libmetis-dev \
  vim.tiny imagemagick git libtbb-dev \
  ros-kinetic-tf* ros-kinetic-pcl* ros-kinetic-opencv* ros-kinetic-urdf && rm -rf /var/lib/apt/lists/*;

# Enable tab completion by uncommenting it from /etc/bash.bashrc
# The relevant lines are those below the phrase "enable bash completion in interactive shells"
RUN export SED_RANGE="$(($(sed -n '\|enable bash completion in interactive shells|=' /etc/bash.bashrc)+1)),$(($(sed -n '\|enable bash completion in interactive shells|=' /etc/bash.bashrc)+7))" && \
  sed -i -e "${SED_RANGE}"' s/^#//' /etc/bash.bashrc && \
  unset SED_RANGE

# Create user "docker" with sudo powers
RUN useradd -m docker && \
  usermod -aG sudo docker && \
  echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
  cp /root/.bashrc /home/docker/ && \
  mkdir -p /home/docker/src/StaticMapping && \
  chown -R --from=root docker /home/docker

# Use C.UTF-8 locale to avoid issues with ASCII encoding
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

WORKDIR /home/docker/src
ENV HOME /home/docker
ENV USER docker
USER docker
ENV PATH /home/docker/.local/bin:$PATH
# Avoid first use of sudo warning. c.f. https://askubuntu.com/a/22614/781671
RUN touch $HOME/.sudo_as_admin_successful

COPY setup/* $HOME/src/
RUN sudo chmod +x $HOME/src/install_libnabo.sh && $HOME/src/install_libnabo.sh
RUN sudo chmod +x install_libpointmatcher.sh && $HOME/src/install_libpointmatcher.sh
RUN sudo chmod +x install_geographiclib.sh && $HOME/src/install_geographiclib.sh
RUN sudo chmod +x install_gtsam.sh && $HOME/src/install_gtsam.sh