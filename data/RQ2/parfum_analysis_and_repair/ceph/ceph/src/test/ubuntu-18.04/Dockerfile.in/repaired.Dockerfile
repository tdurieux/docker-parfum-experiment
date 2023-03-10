#
# Copyright (C) 2016 Red Hat <contact@redhat.com>
#
# Author: Loic Dachary <loic@dachary.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Library Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Library Public License for more details.
#
# Environment variables are substituted via envsubst(1)
#
# user_id=$(id -u)
# os_version= the desired REPOSITORY TAG
#
FROM ubuntu:%%os_version%%

COPY install-deps.sh /root/
RUN mkdir /root/debian
COPY debian /root/debian/
RUN apt-get update && apt-get install --no-install-recommends -y ccache valgrind gdb gdisk kpartx jq xmlstarlet sudo && rm -rf /var/lib/apt/lists/*; # build dependencies
RUN cd /root ; DEBIAN_FRONTEND=noninteractive ./install-deps.sh
# development tools

RUN if test %%USER%% != root ; then useradd -M --uid %%user_id%% %%USER%% && echo '%%USER%% ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers ; fi
