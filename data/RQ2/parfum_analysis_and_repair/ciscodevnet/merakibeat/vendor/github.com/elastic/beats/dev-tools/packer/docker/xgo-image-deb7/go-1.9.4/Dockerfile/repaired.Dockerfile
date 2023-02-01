# Go cross compiler (xgo): Go 1.9.4 layer
# Copyright (c) 2014 Péter Szilágyi. All rights reserved.
#
# Released under the MIT license.

FROM tudorg/xgo-deb7-base

MAINTAINER Tudor Golubenco <tudor@elastic.co>

# Configure the root Go distribution and bootstrap based on it