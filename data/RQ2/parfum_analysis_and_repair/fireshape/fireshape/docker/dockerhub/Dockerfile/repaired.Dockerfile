FROM firedrakeproject/firedrake:latest

MAINTAINER Alberto Paganini <admp1@le.ac.uk>

USER root
RUN apt-get update \
    && apt-get -y dist-upgrade \
    && apt-get -y --no-install-recommends install gmsh patchelf \
    && rm -rf /var/lib/apt/lists/*

USER firedrake
RUN . /home/firedrake/firedrake/bin/activate; pip3 install --no-cache-dir wheel --upgrade
RUN . /home/firedrake/firedrake/bin/activate; pip3 install --no-cache-dir scipy
RUN . /home/firedrake/firedrake/bin/activate; pip3 install --no-cache-dir roltrilinos
RUN . /home/firedrake/firedrake/bin/activate; pip3 install --no-cache-dir ROL
RUN . /home/firedrake/firedrake/bin/activate; pip install --no-cache-dir git+https://github.com/fireshape/fireshape.git
