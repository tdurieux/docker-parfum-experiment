# Go cross compiler (xgo): Go develop layer
# Copyright (c) 2015 Péter Szilágyi. All rights reserved.
#
# Released under the MIT license.

FROM goreng/xgo:base

LABEL MAINTAINER Péter Szilágyi <peterke@gmail.com>

# Clone and bootstrap the latest Go develop branch