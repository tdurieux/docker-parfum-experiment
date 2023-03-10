#
# Labtainer Dockerfile
#
#  This is the default Labtainer Dockerfile template, plesae choose the appropriate
#  base image below.
#
# The labtainer.base image includes the following packages:
#    build-essential  expect  file  gcc-multilib  gdb  iputils-ping  less  man  manpages-dev
#    net-tools  openssh-client  python  sudo  tcl8.6  vim  zip  hexedit  rsyslog
#
# The labtainer.network image adds the following packages:
#   openssl openssh-server openvpn wget tcpdump  update-inetd  xinetd
#
ARG registry
FROM $registry/labtainer.firefox
#FROM $registry/labtainer.network
#FROM $registry/labtainer.centos
#FROM $registry/labtainer.lamp
#
#  lab is the fully qualified image name, e.g., mylab.some_container.student
#  labdir is the name of the lab, e.g., mylab
#  imagedir is the name of the container
#  user_name is the USER from the start.config, if other than ubuntu,
#            then that user must be added in this dockerfile
#            before the USER command
#
ARG lab
ARG labdir
ARG imagedir
ARG user_name
ARG password
ARG apt_source
ARG version
LABEL version=$version
#ENV APT_SOURCE $apt_source
RUN /usr/bin/apt-source.sh
#
#  put package installation here
RUN apt-get update
RUN apt-get install -y --no-install-recommends python-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir future
#RUN apt-get install -y python-wxgtk2.8 pyro python-numpy python-nevow python-matplotlib python-lxml
RUN sudo apt-get install -y --no-install-recommends software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN sudo add-apt-repository --yes ppa:nilarimogard/webupd8
RUN apt-get update
RUN apt-get install -y --no-install-recommends python-wxgtk2.8 pyro python-numpy python-nevow python-matplotlib python-lxml && rm -rf /var/lib/apt/lists/*;
#
#
# Install the system files found in the _system directory
#
ADD $labdir/$imagedir/sys_tar/sys.tar /
ADD $labdir/sys_$lab.tar.gz /
#
RUN useradd -ms /bin/bash $user_name
RUN echo "$user_name:$password" | chpasswd
RUN adduser $user_name sudo
# replace above with below for centos/fedora
#RUN usermod $user_name -a -G wheel


#
#  **** Perform all root operations, e.g.,           ****
#  **** "apt-get install" prior to the USER command. ****
#
RUN apt-get update && apt-get install -y --no-install-recommends \
    git && rm -rf /var/lib/apt/lists/*;
USER $user_name
ENV HOME /home/$user_name
#
# Install files in the user home directory
#
ADD $labdir/$imagedir/home_tar/home.tar $HOME
# remove after docker fixes problem with empty tars
RUN sudo rm -f $HOME/home.tar
ADD $labdir/$lab.tar.gz $HOME
WORKDIR /home/$user_name
RUN git clone https://github.com/thiagoralves/OpenPLC_Editor.git
WORKDIR /home/$user_name/OpenPLC_Editor
RUN sudo /home/$user_name/OpenPLC_Editor/install.sh
RUN sudo pip uninstall -y enum
RUN sudo pip install --no-cache-dir autobahn
RUN sudo rm -fr /usr/lib/python2.7/dist-packages/OpenSSL
RUN sudo rm -fr /usr/lib/python2.7/dist-packages/pyOpenSSL-0*
RUN sudo pip install --no-cache-dir pyopenssl
#RUN sudo apt-get install msgpack-python libsmgpack3
RUN echo "export LANG=en_IN.utf8" >> $HOME/.bashrc
#
#  The first thing that executes on the container.
#
USER root
CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]

