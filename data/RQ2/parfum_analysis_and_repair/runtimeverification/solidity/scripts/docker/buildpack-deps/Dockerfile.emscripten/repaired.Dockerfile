# vim:syntax=dockerfile
#------------------------------------------------------------------------------
# Dockerfile for building and testing Solidity Compiler on CI
# Target: Emscripten
# URL: https://hub.docker.com/r/ethereum/solidity-buildpack-deps
#
# This file is part of solidity.
#
# solidity is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# solidity is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with solidity.  If not, see <http://www.gnu.org/licenses/>
#
# (c) 2016-2019 solidity contributors.
#------------------------------------------------------------------------------
#
# The Emscripten SDK at https://github.com/emscripten-core/emsdk/
# contains a Makefile in the docker/ subdirectory that can be used to create the
# required base image using:
#
#   make version=1.39.15 build
#