# docker file for static mapping

FROM ros:noetic-ros-core-focal

LABEL author="edward" email="liuyongchuan@outook.com"

COPY ./setup/tsinghua_source.focal.txt /etc/apt/sources.list

RUN apt-get -y update && apt-get -y upgrade

RUN apt-get -y --no-install-recommends install cmake gcc g++ libboost-all-dev libeigen3-dev libpng-dev libgoogle-glog-dev libatlas-base-dev \
  libsuitesparse-dev wget libmetis-dev libtbb-dev && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y keyboard-configuration && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y \
  ros-noetic-tf* ros-noetic-pcl* ros-noetic-opencv* ros-noetic-urdf \
  vim.tiny imagemagick libpcl-dev git && rm -rf /var/lib/apt/lists/*;

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

RUN sudo mv /usr/include/flann/ext/lz4.h /usr/include/flann/ext/lz4.h.bak && \
  sudo mv /usr/include/flann/ext/lz4hc.h /usr/include/flann/ext/lz4.hc.bak && \
  sudo ln -s /usr/include/lz4.h /usr/include/flann/ext/lz4.h && \
  sudo ln -s /usr/include/lz4hc.h /usr/include/flann/ext/lz4hc.h