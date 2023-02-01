# Copyright (c) the JPEG XL Project Authors. All rights reserved.
#
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# Build an Ubuntu-based docker image with the installed software needed to
# develop and test JPEG XL.

FROM ubuntu:bionic

# Set a prompt for when using it locally.