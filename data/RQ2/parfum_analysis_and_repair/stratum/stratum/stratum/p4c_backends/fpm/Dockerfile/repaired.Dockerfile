#
# Copyright 2019-present Open Networking Foundation
# SPDX-License-Identifier: Apache-2.0
#

# This Dockerfile expects its containing directory as its scope with the p4c-fpm
# Debian package present, hence you should build it like this:
# bazel build //stratum/p4c_backends/fpm:p4c_fpm_deb
# cp bazel-bin/stratum/p4c_backends/fpm/p4c_fpm_deb.deb stratum/p4c_backends/fpm
# cd stratum/p4c_backends/fpm
# docker build -t <some tag> -f Dockerfile  .