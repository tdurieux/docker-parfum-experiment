#===- libcxx/utils/docker/debian9/Dockerfile --------------------------------------------------===//
#
# Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#
#===-------------------------------------------------------------------------------------------===//

#===-------------------------------------------------------------------------------------------===//
#  compiler-zoo
#===-------------------------------------------------------------------------------------------===//
FROM  ericwf/libcxx-buildbot-base:latest AS compiler-zoo
LABEL maintainer "libc++ Developers"

# Copy over the GCC and Clang installations