# This dockerfile builds the docker image / container
# for OPM, which then is easy to publish on docker hub
# or similar.

# Useful commands use:
# $ docker build -t opm_docker_image -f Dockerfile.rh6 .
# $ docker build --build-arg opm_version=nightly -t opm_docker_image -f Dockerfile.rh6
# $ docker run -v <HOST_DIR>:/shared_host opm_docker_image flow output_dir="/shared_host/output" "/shared_host/<DECK>"

# Use centos 6 as base
FROM centos:6

ARG opm_version=release

# Add yum repo
RUN yum install -y yum-utils epel-release centos-release-scl && rm -rf /var/cache/yum
RUN if [ "$opm_version" = "release" ]; then yum-config-manager --add-repo https://www.opm-project.org/package/opm.repo; fi

RUN if [ "$opm_version" = "nightly" ]; then yum-config-manager --add-repo https://www.opm-project.org/package/opm-nightly.repo; fi

# OPM packages
RUN yum install -y opm-simulators-openmpi-bin libopm-common1-openmpi libopm-grid1-openmpi && rm -rf /var/cache/yum

# Create shared directory
RUN mkdir /shared_host
VOLUME /shared_host

ENV PATH=/usr/lib64/openmpi/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/lib64/openmpi/lib:/usr/lib64/openmpi/lib64:$LD_LIBRARY_PATH

# add path to mpi to start-up scripts
 RUN echo "export PATH=/usr/lib64/openmpi/bin:${PATH}" > /etc/profile.d/scripts-path.sh && \
     echo "export LD_LIBRARY_PATH=/usr/lib64/openmpi/lib64:/usr/lib64/openmpi/lib:$LD_LIBRARY_PATH" >> /etc/profile.d/scripts-path.sh &&\
         chmod 755 /etc/profile.d/scripts-path.sh

RUN adduser opm
USER opm
