FROM  centos/systemd


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
# INSTALL PYTHON 3                  	                                    #
#############################################################################
RUN yum install -y sudo && rm -rf /var/cache/yum
RUN yum install -y which && rm -rf /var/cache/yum
# CentOS legacy rpm links deprecated: https://github.com/iusrepo/announce/issues/18
# RUN sudo yum install -y https://centos7.iuscommunity.org/ius-release.rpm
RUN sudo yum install -y https://repo.ius.io/ius-release-el7.rpm && rm -rf /var/cache/yum
RUN sudo yum -y update
RUN sudo yum install -y python36u python36u-libs gcc python36u-devel python36u-pip && rm -rf /var/cache/yum

RUN ln -sf /usr/bin/python3.6 /usr/bin/python3

#############################################################################
# INSTALL FSWATCH                                                           #
#############################################################################
RUN yum group install -y 'Development Tools'
RUN sudo yum install -y wget && rm -rf /var/cache/yum
RUN wget https://github.com/emcrisostomo/fswatch/releases/download/1.9.3/fswatch-1.9.3.tar.gz
RUN tar -xvzf fswatch-1.9.3.tar.gz && rm fswatch-1.9.3.tar.gz
WORKDIR /fswatch-1.9.3
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
RUN sudo make install
RUN sudo ldconfig

#############################################################################
# INSTALL LSOF                                                              #
#############################################################################
RUN yum -y install lsof && rm -rf /var/cache/yum

WORKDIR /
ADD requirements.txt .
# CLAI REQUIREMENTS
RUN python3 -m pip install --user -r requirements.txt \ 
    && python3 -m pip install --user --upgrade keyrings.alt

#############################################################################
# UPDATE LOCALE                                                             #
#############################################################################
RUN echo "export LC_ALL='en_US.utf8'" >> /root/.bashrc


