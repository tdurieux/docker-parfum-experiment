FROM  centos/systemd
ARG jenkinsbuild=false


################################################################
# Licensed Materials - Property of IBM
# "Restricted Materials of IBM"
# (C) Copyright IBM Corp. 2019 ALL RIGHTS RESERVED
################################################################

##############################################################################
# A docker container for a add a plugin in bash shell that uses machine learning
# to enhance the command line experience.
##############################################################################



############################################################################
# Set up an MOTD: Note this uses a heredoc expression...
############################################################################

RUN echo '[ ! -z "$TERM" -a -r /etc/motd ] && cat /etc/issue && cat /etc/motd' \
    >> /etc/bash.bashrc \
    ; echo -e "\
                                                \n\
   _____   _                   _____            \n\
  / ____| | |          /\     |_   _|           \n\
 | |      | |         /  \      | |             \n\
 | |      | |        / /\ \     | |             \n\
 | |____  | |____   / ____ \   _| |_            \n\
  \_____| |______| /_/    \_\ |_____|           \n\
                                                \n\
"\
    > /etc/motd


#############################################################################
# START of block that enables SSH access                                    #
#############################################################################
# Install the SSH Daemon ....
RUN yum install -y install deltarpm \
    && yum update -y \
    && yum install -y \
        openssh-server \
        openssh-clients && rm -rf /var/cache/yum

RUN mkdir /var/run/sshd \
    && echo 'root:Bashpass' | chpasswd

# SSH login fix. Otherwise user is kicked off after login
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && ssh-keygen -f ~/.ssh/id_rsa -t rsa -N '' \
    # Generate the host keys...
    && /usr/bin/ssh-keygen -A

#RUN yum install -y policycoreutils-python
#RUN semanage fcontext -a -t sshd_key_t "/usr/local/etc/ssh/ssh_host.*_key"
#RUN semanage fcontext -a -t sshd_key_t "/usr/local/etc/ssh/ssh_host.*_key\.pub"
#RUN restorecon -Rv /usr/local/lib/ssh

# Allow port 22 to be opened...
EXPOSE 22
#############################################################################
# END of block that enables SSH access                                      #
#############################################################################

#############################################################################
# INSTALL PYTHON 3                  	                                    #
#############################################################################
RUN yum install -y \
            sudo \
            which && rm -rf /var/cache/yum

# CentOS legacy rpm links deprecated: https://github.com/iusrepo/announce/issues/18
# RUN sudo yum install -y https://centos7.iuscommunity.org/ius-release.rpm \
RUN sudo yum install -y https://repo.ius.io/ius-release-el7.rpm \
    && sudo yum -y update \
    && sudo yum install -y \
                python36u \
                python36u-libs \
                gcc \
                python36u-devel \
                python36u-pip \
    && ln -sf /usr/bin/python3.6 /usr/bin/python3 && rm -rf /var/cache/yum

#############################################################################
# INSTALL FSWATCH                                                           #
#############################################################################
RUN yum group install -y 'Development Tools' \
    && sudo yum install -y wget && rm -rf /var/cache/yum

RUN wget https://github.com/emcrisostomo/fswatch/releases/download/1.9.3/fswatch-1.9.3.tar.gz \
    && tar -xvzf fswatch-1.9.3.tar.gz && rm fswatch-1.9.3.tar.gz

WORKDIR /fswatch-1.9.3

RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && sudo make install \
    && sudo ldconfig

#############################################################################
# INSTALL LSOF                                                              #
#############################################################################
RUN yum -y install lsof && rm -rf /var/cache/yum

#############################################################################
# INSTALL THE SHELL 	                                                    #
#############################################################################
RUN mkdir -p /opt/IBM/clai/
WORKDIR /opt/IBM/clai/
ADD . .
RUN if [ "$jenkinsbuild" = "true" ] ; then \
        sudo pip3 install --no-cache-dir -r -r requirements.txt requirements_test.txt -r; \
    else \
        sudo pip3 install --no-cache-dir -r requirements.txt; \
    fi \
    && sudo python3 install.py --unassisted --shell bash

#############################################################################
# END Install the shell                                                     #
#############################################################################

#############################################################################
# UPDATE LOCALE                                                             #
#############################################################################
RUN echo "export LC_ALL='en_US.utf8'" >> /root/.bashrc

##############################################################
# Finally we provide the command to start DiamondPoint at boot
# and allow interactive access to the container with bash
##############################################################
# The CMD is the default command run when the docker container is started.
# We need to use 'basename' to determine the full jar filename since it is
# generated with a different timestamp every time we build
# CMD ["sudo setenforce 0 && /usr/sbin/sshd", "-D"]
