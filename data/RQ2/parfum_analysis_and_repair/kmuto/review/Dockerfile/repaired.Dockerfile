# This file is a sample Dockerfile to build Re:VIEW documents.
#
# Build:
#   $ docker build -t review .
#
# Usage:
#   $ cd path/to/review/project
#   $ docker run -it --rm -v `pwd`:/work review rake pdf
#
# cf. https://github.com/vvakame/docker-review/blob/master/Dockerfile