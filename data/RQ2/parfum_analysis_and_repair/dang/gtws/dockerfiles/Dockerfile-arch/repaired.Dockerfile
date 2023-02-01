# Docker file to customize for a workspace
#

FROM      @BASEIMAGE@
MAINTAINER @MAINTAINER@

ENV user=@USER@ uid=@UID@ group=@GROUP@ gid=@GID@ shell=/bin/bash

LABEL Description="This is used for @PROJECT@ development by ${user}" Vendor="Fprintf Networks" Version="1.0"

RUN groupadd -g ${gid} ${group}
RUN useradd -u ${uid} -g ${group} -G wheel -s ${shell} -m ${user}
RUN pacman --noconfirm -Syu
RUN pacman --noconfirm -S lsb-release git vim sudo cscope ctags python @EXTRA_PKGS@

# Homedir and environment
USER ${user}
WORKDIR /home/${user}
ADD scripts-setup ./
RUN rm -f .bash*
RUN ./scripts-setup .scripts

# Workspace