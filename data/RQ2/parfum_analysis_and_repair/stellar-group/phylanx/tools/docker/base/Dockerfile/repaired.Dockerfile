# Copyright (c) 2017 R. Tohid
# Copyright (c) 2018-2019 Parsa Amini
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#
# This is the base image used for building Phylanx. It adds the following to
# the HPX image containing the debug build of HPX built during HPX's CI
# workflow:
#
#  - Python 3
#  - Python Pacakges
#      - SetupTools
#      - flake
#      - PyTest
#      - NumPy
#  - pybind11
#  - OpenBLAS and LAPACK
#  - blaze
#  - HDF5
#  - HighFive