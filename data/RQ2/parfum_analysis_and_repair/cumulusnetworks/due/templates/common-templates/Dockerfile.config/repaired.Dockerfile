# Copyright 2019,2020 Cumulus Networks, Inc.  All rights reserved.
#
#  SPDX-License-Identifier:     MIT

# This file holds definitions for  LABEL values that DUE may interpret
# before running the image
# These are put into the Dockerfile before creation

# The current working directory on the host system will be mounted
# For non zero values, this moves up an equivalent number of directories.
LABEL DUEMountHostDirsUp=0

# Role of container
LABEL DUEImageType=due-default

# Version of container, for future compatibility