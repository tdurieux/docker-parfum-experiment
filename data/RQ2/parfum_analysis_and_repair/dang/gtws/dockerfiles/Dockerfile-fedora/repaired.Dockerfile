# Docker file to customize for a workspace
#

FROM      @BASEIMAGE@
MAINTAINER @MAINTAINER@

ENV user=@USER@ uid=@UID@ group=@GROUP@ gid=@GID@ shell=/bin/bash

LABEL Description="This is used for @PROJECT@ development by ${user}" Vendor="Fprintf Networks" Version="1.0"

USER root
RUN groupadd -f -g ${gid} ${group}
RUN useradd -u ${uid} -g ${group} -G wheel -s ${shell} -m ${user}
RUN echo "${user}:${user}" | chpasswd
RUN dnf -y install git vim sudo procps cscope @EXTRA_PKGS@

# Homedir and environment
USER ${user}
WORKDIR /home/${user}
ADD scripts-setup ./
RUN rm -f .bash*
RUN ./scripts-setup .scripts

# Workspace