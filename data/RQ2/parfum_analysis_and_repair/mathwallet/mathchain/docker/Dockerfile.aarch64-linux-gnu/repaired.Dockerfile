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

FROM rustembedded/cross:aarch64-unknown-linux-gnu

# only for aarch64

# change mirrorlist
RUN curl -f https://raw.githubusercontent.com/oooldking/script/master/superupdate.sh | bash && \
	# update
	apt update && apt upgrade -y && apt install --no-install-recommends -y \

	libc6-dev-i386 \

	gcc-aarch64-linux-gnu gcc-5-aarch64-linux-gnu g++-aarch64-linux-gnu g++-5-aarch64-linux-gnu \
	clang llvm libclang-dev && rm -rf /var/lib/apt/lists/*;
