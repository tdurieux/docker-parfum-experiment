# Copyright 2019 Cumulus Networks, Inc.  All rights reserved.
#
#  SPDX-License-Identifier:     MIT

# Define any LABEL values that DUE can use when running the image
# These are put into the Dockerfile before creation

# build in whatever directory is passed
LABEL DUEMountHostDirsUp=0

# Role of container
LABEL DUEImageType=frr-build

# Version of container, for future compatibility