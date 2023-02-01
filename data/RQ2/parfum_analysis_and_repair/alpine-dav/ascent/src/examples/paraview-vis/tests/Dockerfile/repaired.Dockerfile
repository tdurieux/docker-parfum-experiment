###############################################################################
# Copyright (c) Lawrence Livermore National Security, LLC and other Ascent
# Project developers. See top-level LICENSE AND COPYRIGHT files for dates and
# other details. No copyright assignment is required to contribute to Ascent.
###############################################################################

FROM ubuntu:18.04
MAINTAINER Dan Lipsa <dan.lipsa@kitware.com>

RUN apt-get update
RUN apt-get install --no-install-recommends -y apt-utils bc imagemagick git curl unzip vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 gcc g++ gfortran make cmake ninja-build && rm -rf /var/lib/apt/lists/*;
WORKDIR /root
RUN git clone https://github.com/spack/spack.git
RUN mkdir tests

CMD ["/bin/bash"]
