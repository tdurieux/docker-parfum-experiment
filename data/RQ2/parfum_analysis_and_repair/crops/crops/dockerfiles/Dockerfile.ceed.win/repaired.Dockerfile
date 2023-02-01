# This file describes the standard way to cross compile ceed with mingw
#
# Example:
#
# docker build -t crops/ceed:0.1 -f Dockerfile.ceed.win ../

FROM crops/ceed:deps
MAINTAINER Todor Minchev <todor.minchev@linux.intel.com>
LABEL name="ceed-windows"

# Build and install CEED