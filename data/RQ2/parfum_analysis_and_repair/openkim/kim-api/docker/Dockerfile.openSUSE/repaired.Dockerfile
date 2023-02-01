#
# KIM-API: An API for interatomic models
# Copyright (c) 2013--2022, Regents of the University of Minnesota.
# All rights reserved.
#
# Contributors:
#    Christoph Junghans
#    Ryan S. Elliott
#    Daniel S. Karls
#
# SPDX-License-Identifier: LGPL-2.1-or-later
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this library; if not, write to the Free Software Foundation,
# Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#

#
# Release: This file is part of the kim-api-2.3.0 package.
#


FROM opensuse/tumbleweed

RUN zypper -n install \
        ccache \
        cmake \
        findutils \
        git \
        gcc \
        gcc-c++ \
        gcc-fortran \
        include-what-you-use \
        libasan6 \
        make \
        sysuser-shadow \
        tar \
        vim \
        wget \
        xz

# specify build prefix to be used (optional)
ARG B_INSTALL_PREFIX="/usr"
ENV INSTALL_PREFIX ${B_INSTALL_PREFIX}

# specify directories where build files should be found
# for this distribution (optional)