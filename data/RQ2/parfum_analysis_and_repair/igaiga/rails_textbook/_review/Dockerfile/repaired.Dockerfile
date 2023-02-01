# This file is a sample Dockerfile to build Re:VIEW documents.
#
# Build Docker image:
#   $ docker build -t review .
#
# Build PDF:
#   $ docker run --rm -v `pwd`/_review:/work review /bin/sh -c "cd /work && rake pdf"
#
# cf. https://github.com/vvakame/docker-review/blob/master/Dockerfile