# Define you base image for build arguments
ARG IMG
ARG VERSION
ARG ORG
FROM ${ORG}/${IMG}:${VERSION}

# Uninstall some packages, install others.
# I use those for clion, but VS code would have different requirements.
# Use yum's equivalent commands for centos/red-hat images.
# Feel free to adapt.
RUN apt-get update
RUN apt-get remove --purge -y texlive graphviz
RUN apt-get install --no-install-recommends -y openssh-server gdb rsync gdbserver ninja-build && rm -rf /var/lib/apt/lists/*;

# You will need cmake to build GEOSX.
ARG CMAKE_VERSION=3.16.8
RUN apt-get install -y --no-install-recommends curl ca-certificates && \
    curl -fsSL https://cmake.org/files/v${CMAKE_VERSION%.[0-9]*}/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz | tar --directory=/usr/local --strip-components=1 -xzf - && \
    apt-get purge --auto-remove -y curl ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN apt-get autoremove -y

# You'll most likely need ssh/sshd too (e.g. CLion and VSCode allow remote dev through ssh).
# This is the part where I configure sshd.

# I'm developing in a version of docker that requires root.
# So by default I use root. Feel free to adapt.
RUN echo "PermitRootLogin prohibit-password" >> /etc/ssh/sshd_config
RUN echo "PermitUserEnvironment yes" >> /etc/ssh/sshd_config
RUN mkdir -p -m 700 /root/.ssh
# Put your own public key here!
RUN echo "ssh-rsa [#a public ssh key]" > /root/.ssh/authorized_keys

# Some important variables are provided through the environment.
# You need to explicitly tell sshd to forward them.
# Using these variables and not paths will let you adapt to different installation locations in different containers.
# Feel free to adapt to your own convenience.
RUN touch /root/.ssh/environment &&\
    echo "CC=${CC}" >> /root/.ssh/environment &&\
    echo "CXX=${CXX}" >> /root/.ssh/environment &&\
    echo "MPICC=${MPICC}" >> /root/.ssh/environment &&\
    echo "MPICXX=${MPICXX}" >> /root/.ssh/environment &&\
    echo "MPIEXEC=${MPIEXEC}" >> /root/.ssh/environment &&\
    echo "OMPI_CC=${CC}" >> /root/.ssh/environment &&\
    echo "OMPI_CXX=${CXX}" >> /root/.ssh/environment &&\
    echo "GEOSX_TPL_DIR=${GEOSX_TPL_DIR}" >> /root/.ssh/environment

# This is the default ssh port that we do not need to modify.
EXPOSE 22
# sshd's option -D prevents it from detaching and becoming a daemon.
# Otherwise, sshd would not block the process and `docker run` would quit.
RUN mkdir -p /run/sshd
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
