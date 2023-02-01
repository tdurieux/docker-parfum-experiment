FROM ubuntu:20.04
ARG GID
ARG UID
RUN echo "Group ID: $GID"
RUN echo "User ID: $UID"

USER root
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata --assume-yes && rm -rf /var/lib/apt/lists/*;

# Install Essential Packages
RUN apt-get install -y --no-install-recommends build-essential libtool autoconf pkg-config flex bison libgmp-dev clang-9 libclang-9-dev texinfo cmake vim ninja-build git --assume-yes && rm -rf /var/lib/apt/lists/*;

RUN update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-9 100
RUN update-alternatives --install /usr/bin/FileCheck FileCheck /usr/bin/FileCheck-9 100
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-9 100
RUN update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-9 100

CMD ["bash"]

RUN apt-get install -y --no-install-recommends sudo --assume-yes && rm -rf /var/lib/apt/lists/*;

# Add dev-user
RUN groupadd -g $GID dev-user
RUN useradd -r -g $GID -u $UID -m -d /home/dev-user -s /sbin/nologin -c "User" dev-user
RUN echo "dev-user     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER dev-user

RUN echo 'PATH=$PATH:/workspace/llvm/build/bin:/workspace/build/bin' >> /home/dev-user/.bashrc
RUN echo 'LD_LIBRARY_PATH=/workspace/build/pluto/lib:$LD_LIBRARY_PATH' >> /home/dev-user/.bashrc
WORKDIR workspace
