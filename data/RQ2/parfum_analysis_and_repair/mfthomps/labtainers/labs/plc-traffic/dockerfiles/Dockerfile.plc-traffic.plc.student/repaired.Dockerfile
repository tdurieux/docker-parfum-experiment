#
# Labtainer Dockerfile
#
# The labtainer.base image includes the following packages:
#    build-essential  expect  file  gcc-multilib  gdb  iputils-ping  less  man  manpages-dev
#    net-tools  openssh-client  python  sudo  tcl8.6  vim  zip  hexedit  rsyslog
#
# The labtainer.network image adds the following packages:
#   openssl openssh-server openvpn wget tcpdump  update-inetd  xinetd
#
ARG registry
FROM $registry/labtainer.wireshark
ARG lab
ARG labdir
ARG imagedir
ARG user_name
# Need nodejs to start OpenPLC server
ENV APT_SOURCE $apt_source
RUN /usr/bin/apt-source.sh
RUN apt-get update && apt-get install -y --no-install-recommends \
    git && rm -rf /var/lib/apt/lists/*;
ADD $labdir/$imagedir/sys_tar/sys.tar /
ADD $labdir/sys_$lab.tar.gz /

RUN useradd -ms /bin/bash $user_name
RUN echo "$user_name:$user_name" | chpasswd
RUN adduser $user_name sudo
USER $user_name
ENV HOME /home/$user_name
ADD $labdir/$lab.tar.gz $HOME

WORKDIR /home/$user_name
RUN git clone https://github.com/mfthomps/OpenPLC_v3.git
WORKDIR /home/$user_name/OpenPLC_v3
RUN sudo ./install.sh linux

USER root
CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]

