# Monocle.
# Copyright (C) 2021 Monocle authors
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Update the builder image with:
#  TMPDIR=/tmp/ podman build -f Dockerfile-build -t quay.io/change-metrics/builder .
#  podman push quay.io/change-metrics/builder

# base image
FROM registry.fedoraproject.org/fedora:35
ENV LANG=C.UTF-8
WORKDIR /build

# Install haskell toolchain
RUN dnf update -y && dnf install -y git ghc cabal-install openssl-devel zlib-devel
RUN cabal v2-update

# Install project dependencies