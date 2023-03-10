# Dockerfile to build a manylinux 2010 compliant cross-compiler.
#
# Builds a devtoolset gcc/libstdc++ that targets manylinux 2010 compatible
# glibc (2.12) and system libstdc++ (4.4).
#
# To push a new version, run:
# $ docker build -f Dockerfile.rbe.ubuntu16.04-manylinux2010 \
#  --tag "gcr.io/tensorflow-testing/nosla-ubuntu16.04-manylinux2010" .
# $ docker push gcr.io/tensorflow-testing/nosla-ubuntu16.04-manylinux2010

FROM ubuntu:16.04 as devtoolset

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
      bzip2 \
      cpio \
      file \
      flex \
      g++ \
      make \
      patch \
      rpm2cpio \
      unar \
      wget \
      tar \
      xz-utils \
      && \
    rm -rf /var/lib/apt/lists/*

ADD devtoolset/fixlinks.sh fixlinks.sh
ADD devtoolset/build_devtoolset.sh build_devtoolset.sh
ADD devtoolset/rpm-patch.sh rpm-patch.sh

# Set up a sysroot for glibc 2.12 / libstdc++ 4.4 / devtoolset-7 in /dt7.
RUN /build_devtoolset.sh devtoolset-7 /dt7
# Set up a sysroot for glibc 2.12 / libstdc++ 4.4 / devtoolset-8 in /dt8.
RUN /build_devtoolset.sh devtoolset-8 /dt8

# TODO(klimek): Split up into two different docker images.
FROM ubuntu:16.04
COPY --from=devtoolset /dt7 /dt7
COPY --from=devtoolset /dt8 /dt8

# Copy and run the install scripts.
COPY install/*.sh /install/
ARG DEBIAN_FRONTEND=noninteractive
RUN /install/install_bootstrap_deb_packages.sh
RUN /install/install_deb_packages.sh
RUN /install/install_clang.sh
RUN /install/install_bazel.sh

# Install golang.
RUN /install/install_golang.sh
env GOROOT=/usr/local/go
env PATH=$GOROOT/bin:$PATH

# Install python 3.6.
RUN yes "" | add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update && apt-get install --no-install-recommends -y \
    python3.6 python3.6-dev python3-pip python3.6-venv && \
    rm -rf /var/lib/apt/lists/* && \
    python3.6 -m pip install pip --upgrade && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 0

RUN /install/install_pip_packages.sh

# Install python 3.8.
RUN apt-get update && apt-get install --no-install-recommends -y python3.8 python3.8-dev python3.8-venv && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/*
# Have to download get-pip.py due to a pip circular issue
# https://stackoverflow.com/questions/58758447/how-to-fix-module-platform-has-no-attribute-linux-distribution-when-instal
RUN curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python3.8 get-pip.py
RUN python3.8 -m pip install --upgrade pip setuptools wheel

# Overwrite include paths that are generated for the multipython image.
RUN ln -sf "/usr/include/x86_64-linux-gnu/python2.7" "/dt7/usr/include/x86_64-linux-gnu/python2.7"
RUN ln -sf "/usr/include/x86_64-linux-gnu/python2.7" "/dt8/usr/include/x86_64-linux-gnu/python2.7"

RUN ln -sf "/usr/include/x86_64-linux-gnu/python3.6m" "/dt7/usr/include/x86_64-linux-gnu/python3.6m"
RUN ln -sf "/usr/include/x86_64-linux-gnu/python3.6m" "/dt8/usr/include/x86_64-linux-gnu/python3.6m"

RUN ln -sf "/usr/include/x86_64-linux-gnu/python3.8" "/dt7/usr/include/x86_64-linux-gnu/python3.8"
RUN ln -sf "/usr/include/x86_64-linux-gnu/python3.8" "/dt8/usr/include/x86_64-linux-gnu/python3.8"
