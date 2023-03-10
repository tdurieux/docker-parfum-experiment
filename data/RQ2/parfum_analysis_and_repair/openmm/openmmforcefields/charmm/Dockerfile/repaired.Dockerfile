FROM ubuntu:14.04
RUN apt-get update && apt-get install --no-install-recommends -y \
        csh \
        gfortran \
        build-essential && rm -rf /var/lib/apt/lists/*;
ADD charmm.tar.gz /
RUN cd charmm && tool/NewCharmmTree c40b1_gnu && cd c40b1_gnu && ./install.com gnu gfortran || cat /charmm/c40b1_gnu/build/gnu/gnu.log
