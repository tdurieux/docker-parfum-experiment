FROM multi2sim/multi2sim:build-env
MAINTAINER NUCAR

# Build Multi2Sim
RUN cd /tmp && git clone https://github.com/Multi2Sim/multi2sim.git && cd multi2sim && libtoolize && aclocal && autoconf && automake --add-missing && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install
