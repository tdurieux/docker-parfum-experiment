FROM centos:%%OS_VERSION%%

LABEL maintainer="Nektar++ Development Team <nektar-users@imperial.ac.uk>"

ENV CENTOS_VERSION %%OS_VERSION%%
COPY docker/nektar-env/${CENTOS_VERSION}_default_packages.txt packages.txt

RUN yum install -y epel-release && \
	yum install -y $(cat packages.txt) \
	&& yum clean all && rm -rf /var/cache/yum

# openmpi installs to a non-standard location on centos7
# below env vars added to help out cmake
ENV LD_LIBRARY_PATH /usr/lib64/openmpi/lib/
ENV PATH /usr/lib64/openmpi/bin/:$PATH

RUN ln -s /usr/bin/ccache /usr/local/bin/cc && ln -s /usr/bin/ccache /usr/local/bin/c++
# The cmake3 package installs cmake3, ctest3, cpack3 executables.
# Create symlinks to provide expected cmake, ctest and cpack executables
RUN ln -s /usr/bin/cmake3 /usr/bin/cmake && ln -s /usr/bin/ctest3 /usr/bin/ctest && ln -s /usr/bin/cpack3 /usr/bin/cpack

RUN groupadd nektar && useradd -m -g nektar nektar
USER nektar:nektar
RUN mkdir /home/nektar/nektar
WORKDIR /home/nektar/nektar
