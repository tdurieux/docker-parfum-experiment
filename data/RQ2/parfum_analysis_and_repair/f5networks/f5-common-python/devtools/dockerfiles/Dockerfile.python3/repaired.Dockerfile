# Dockerfile to build python 3 environment
#
# This dockerfile can be used to build the same python2 environment that we
# use for testing and development. To build the docker container, run the
# following commands.
#
#     cd devtools/dockerfiles
#     docker build -f Dockerfile.python2 -t python3 .
#
# The docker container can then be used as any other docker containter would
# be used. Connecting to your BIG-IP inside of Vagrant may require that you
# add a forwarded host in Docker to the Vagrant machine itself.
#
# For example,
#
#     docker run -it --add-host="localhost:192.168.1.1" \
#         -v "${HOME}/src/trupp/f5-common-python:/artifacts" python2
#
# The 192.x address in this case is the IP address of vboxnet0 interfaces on
# your host machine (the one that runs docker and vagrant)

FROM python:3
MAINTAINER @f5networks

COPY . /tmp/src/

RUN mkdir -p /artifacts/coverage
RUN apt-get update && apt-get -y --no-install-recommends install apt-utils vim && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp/src
RUN pip install --no-cache-dir -r /tmp/src/requirements.test.txt
RUN rm -rf /tmp/src

WORKDIR /artifacts
CMD /bin/bash