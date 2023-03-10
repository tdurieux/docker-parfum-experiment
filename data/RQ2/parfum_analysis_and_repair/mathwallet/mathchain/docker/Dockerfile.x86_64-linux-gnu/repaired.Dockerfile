# This file is part of Darwinia.

# Copyright (C) 2018-2020 Darwinia Networks
# SPDX-License-Identifier: GPL-3.0

# Darwinia is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Darwinia is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Darwinia.  If not, see <https://www.gnu.org/licenses/>.

FROM centos:7

# for gernal linux
# change mirrorlist
RUN curl -f -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo && yum makecache \
	# update
	yum -y update && yum -y upgrade && yum -y install \
	# tool
	git make \
	# compiler
	clang gcc gcc-c++ llvm && rm -rf /var/cache/yum
