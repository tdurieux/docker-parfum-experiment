# SPDX-FileCopyrightText: © 2020 Alias Developers
#
# SPDX-License-Identifier: MIT

### At first perform source build ###
FROM aliascash/alias-wallet-builder-opensuse-tumbleweed:2.6
MAINTAINER HLXEasy <hlxeasy@gmail.com>

# Build parameters
ARG BUILD_THREADS="6"

# Runtime parameters