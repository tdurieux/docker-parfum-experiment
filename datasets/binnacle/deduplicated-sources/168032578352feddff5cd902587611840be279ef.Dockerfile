#################################################################
# Creates a base CentOS 6 image with sshd
#
#                    ##        .
#              ## ## ##       ==
#           ## ## ## ##      ===
#       /""""""""""""""""\___/ ===
#  ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~
#       \______ o          __/
#         \    \        __/
#          \____\______/
#
# Author:    Paolo Antinori <paolo.antinori@gmail.com>
# License:   MIT
#################################################################

FROM centos:centos6

MAINTAINER Paolo Antinori <paolo.antinori@gmail.com>

# telnet is required by some fabric command. without it you have silent failures
RUN yum install -y which unzip openssh-server sudo openssh-clients initscripts ; yum -y clean all
# enable no pass and speed up authentication
RUN sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/;s/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config

# enabling sudo group
RUN echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
# enabling sudo over ssh
RUN sed -i 's/.*requiretty$/#Defaults requiretty/' /etc/sudoers

# add a user for the application, with sudo permissions
RUN useradd -m fuse ; echo fuse: | chpasswd ; usermod -a -G wheel fuse

# assigning higher default ulimits
# unluckily this is not very portable. these values work only if the user running docker daemon on the host has his own limits >= than values set here
# if they are not, the risk is that the "su fuse" operation will fail
RUN echo "fuse                -       nproc           4096" >> /etc/security/limits.conf
RUN echo "fuse                -       nofile           4096" >> /etc/security/limits.conf

RUN echo "export LANG=C" >> /etc/profile

RUN echo "alias ll='ls -l --color=auto'" >> /etc/profile
RUN echo "alias grep='grep --color=auto'" >> /etc/profile
RUN echo "export PS1=\"\[\033[38;5;9m\]\u\[\$(tput sgr0)\]\[\033[38;5;15m\]@\[\$(tput sgr0)\]\[\033[38;5;229m\]\$(ip addr show dev eth0 | grep \"inet \" | cut -d\" \" -f6)\[\$(tput sgr0)\]\[\033[38;5;15m\]:\w\\$ \[\$(tput sgr0)\]\"" >> /etc/bashrc



CMD service sshd start ; bash

EXPOSE 22
