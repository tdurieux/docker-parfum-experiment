###########################################################################
# GLUED: GNU/Linux Uniform Environment Distribution                       #
# Copyright (C) 2016 OceanScan - Marine Systems & Technology, Lda.        #
###########################################################################
# This program is free software; you can redistribute it and/or modify    #
# it under the terms of the GNU General Public License as published by    #
# the Free Software Foundation; either version 2 of the License, or (at   #
# your option) any later version.                                         #
#                                                                         #
# This program is distributed in the hope that it will be useful, but     #
# WITHOUT ANY WARRANTY; without even the implied warranty of              #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU       #
# General Public License for more details.                                #
#                                                                         #
# You should have received a copy of the GNU General Public License       #
# along with this program; if not, write to the Free Software             #
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA           #
# 02110-1301 USA.                                                         #
###########################################################################
# Author: Ricardo Martins                                                 #
###########################################################################

FROM debian:8

MAINTAINER Ricardo Martins <rasm@oceanscan-mst.com>

ENV DEBIAN_FRONTEND noninteractive

# Update distro.
RUN apt-get update -y
RUN apt-get dist-upgrade -y
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y bzip2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y g++-multilib && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y file && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y kmod && rm -rf /var/lib/apt/lists/*;
RUN sed -i 's#mozilla\/DST_Root_CA_X3.crt#!mozilla\/DST_Root_CA_X3.crt#g' /etc/ca-certificates.conf && update-ca-certificates --fresh
