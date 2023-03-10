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



#RUN yum install -y policycoreutils-python
# Allow port 22 to be opened...
EXPOSE 22
#############################################################################
# END of block that enables SSH access                                      #
#############################################################################

#############################################################################
# INSTALL PYTHON 3                  	                                    #
#############################################################################
RUN yum install -y sudo && rm -rf /var/cache/yum
RUN yum install -y which && rm -rf /var/cache/yum

# CentOS legacy rpm links deprecated: https://github.com/iusrepo/announce/issues/18
# RUN yum install -y https://centos7.iuscommunity.org/ius-release.rpm
RUN yum install -y https://repo.ius.io/ius-release-el7.rpm && rm -rf /var/cache/yum

RUN yum -y update
RUN yum install -y python36u python36u-libs gcc python36u-devel python36u-pip && rm -rf /var/cache/yum

RUN ln -sf /usr/bin/python3.6 /usr/bin/python3


#############################################################################
# INSTALL LSOF                                                              #
#############################################################################
RUN yum -y install lsof && rm -rf /var/cache/yum


#############################################################################
# INSTALL THE SHELL 	                                                    #
#############################################################################
RUN mkdir -p /opt/IBM/clai/
WORKDIR /opt/IBM/clai/
add . .
RUN pip3 install --no-cache-dir -r requirements.txt
RUN sudo python3 install.py --unassisted --shell bash

#############################################################################
# END Install the shell                                                     #
#############################################################################

#############################################################################
# UPDATE LOCALE                                                             #
#############################################################################
RUN echo "export LC_ALL='en_US.utf8'" >> /root/.bashrc

