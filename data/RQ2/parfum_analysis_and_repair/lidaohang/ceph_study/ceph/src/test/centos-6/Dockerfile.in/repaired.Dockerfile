#
# Copyright (C) 2015 Red Hat <contact@redhat.com>
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
FROM centos:%%os_version%%
COPY install-deps.sh /root/
COPY ceph.spec.in /root/
RUN yum install -y yum-utils && yum-config-manager --add-repo https://dl.fedoraproject.org/pub/epel/6/x86_64/ && yum install --nogpgcheck -y epel-release && rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6 && rm /etc/yum.repos.d/dl.fedoraproject.org* && rm -rf /var/cache/yum
# build dependencies
RUN yum install -y which ; rm -rf /var/cache/yum cd /root ; ./install-deps.sh
# development tools
# nc is required to run make check on firefly only (giant+ do not use nc)
RUN yum install -y ccache valgrind gdb git python-virtualenv gdisk kpartx jq sudo xmlstarlet parted nc && rm -rf /var/cache/yum
RUN if test %%USER%% != root ; then useradd -M --uid %%user_id%% %%USER%% && echo '%%USER%% ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers ; fi
