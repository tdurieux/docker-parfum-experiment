# Copyright 2019 Cumulus Networks, Inc.  All rights reserved.
#
#  SPDX-License-Identifier:     MIT

# Define any LABEL values that DUE can use when running the image
# These are put into the Dockerfile before creation

# If given a build directory, mount the directory above it
# in the container so the built debs are not left in the
# container
LABEL DUEMountHostDirsUp=1

# Container role
LABEL DUEImageType=example-container

# Version of container, for future compatibility
LABEL DUEContainerVersion=1

# Comma separated list of host directories to mount in the container.
# Useful for sharing host files among multiple containers.
# LABEL DUEMountHostDirectories=/tmp,/var/www/html