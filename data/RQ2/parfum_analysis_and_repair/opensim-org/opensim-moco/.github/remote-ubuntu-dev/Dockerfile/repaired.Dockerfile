# https://github.com/shuhaoliu/docker-clion-dev/blob/master/Dockerfile
# Password for user 'debugger' is pwd.
# We assume the build context is the .../opensim-moco/dependencies directory.

FROM ubuntu

########################################################
# Essential packages for remote debugging and login in
########################################################

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
    apt-utils gcc g++ openssh-server cmake build-essential gdb gdbserver rsync \
    vim && rm -rf /var/lib/apt/lists/*;

# Taken from - https://docs.docker.com/engine/examples/running_ssh_service/#environment-variables

RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# 22 for ssh server. 7777 for gdb server.
EXPOSE 22 7777

RUN useradd -ms /bin/bash debugger
RUN echo 'debugger:pwd' | chpasswd

########################################################
# Add custom packages and development environment here
########################################################

ARG BTYPE=RelWithDebInfo

# Avoid interactive timezone prompt when installing packages.
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
        git \
        build-essential libtool autoconf \
        cmake \
        gfortran \
        wget \
        pkg-config \
        libopenblas-dev \
        liblapack-dev \
        python3 python3-dev python3-numpy python3-matplotlib python3-setuptools \
        swig && rm -rf /var/lib/apt/lists/*;

COPY opensim-core /opensim-core
COPY dependencies/CMakeLists.txt dependencies/*.cmake /dependencies/

RUN mkdir /moco_dependencies_build \
        && cd /moco_dependencies_build \
        && cmake /dependencies -DOPENSIM_PYTHON_WRAPPING=on -DCMAKE_BUILD_TYPE=$BTYPE \
        && make --jobs $(nproc) ipopt \
        && make --jobs $(nproc) \
        && echo "/moco_dependencies_install/adol-c/lib64" >> /etc/ld.so.conf.d/moco.conf \
        && echo "/moco_dependencies_install/ipopt/lib" >> /etc/ld.so.conf.d/moco.conf \
        && ldconfig \
        && rm -r /moco_dependencies_build

########################################################

CMD ["/usr/sbin/sshd", "-D"]
