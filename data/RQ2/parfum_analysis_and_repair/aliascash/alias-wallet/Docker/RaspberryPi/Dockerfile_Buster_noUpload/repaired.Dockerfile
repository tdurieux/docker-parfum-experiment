# SPDX-FileCopyrightText: © 2020 Alias Developers
# SPDX-FileCopyrightText: © 2016 SpectreCoin Developers
#
# SPDX-License-Identifier: MIT

### At first perform source build ###
FROM aliascash/alias-wallet-builder-raspi-buster:2.6
MAINTAINER HLXEasy <hlxeasy@gmail.com>

# Build parameters
ARG BUILD_THREADS="6"

# Runtime parameters