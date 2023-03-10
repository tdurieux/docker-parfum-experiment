# This docker container can be used to run all the TFLM CI checks.
#
# It is only used as part of the GitHub workflows to test for code-style. But
# the container is available and ready for use to run all the checks locally,
# in case that is useful for debugging. See all the versions at
# https://github.com/users/TFLM-bot/packages/container/tflm-ci/versions
#
# docker pull ghcr.io/tflm-bot/tflm-ci:<version>
#
# Build you own container with:
# docker build -f ci/Dockerfile.micro -t tflm-ci .
#
# Use a prebuilt Python image instead of base Ubuntu to speed up the build process,
# since it has all the build dependencies we need for Micro and downloads much faster
# than the install process.
FROM python:3.9.0-buster

RUN echo deb http://apt.llvm.org/buster/ llvm-toolchain-buster-12 main > /etc/apt/sources.list.d/llvm.list
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -

RUN apt-get update

RUN apt-get install --no-install-recommends -y zip xxd sudo && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y clang-12 clang-format-12 && rm -rf /var/lib/apt/lists/*;
# Set clang-12 and clang-format-12 as the default to ensure that the pigweed
# formatting scripts use the desired version.
RUN ln -s /usr/bin/clang-12 /usr/bin/clang
RUN ln -s /usr/bin/clang++-12 /usr/bin/clang++
RUN ln -s /usr/bin/clang-format-12 /usr/bin/clang-format

# Install yapf to check for Python formatting as part of the TFLM continuous
# integration.
RUN pip install --no-cache-dir yapf==0.32.0

# Pillow was added first for the C array generation as a result of the following
# PRs:
# https://github.com/tensorflow/tflite-micro/pull/337
# https://github.com/tensorflow/tflite-micro/pull/410
RUN pip install --no-cache-dir Pillow
RUN pip install --no-cache-dir Wave

# necessary bits for create_size_log scripts
RUN pip install --no-cache-dir pandas
RUN pip install --no-cache-dir matplotlib

RUN pip install --no-cache-dir six

# The following is necessary to build the Python interpreter
# `PYTHON_BIN_PATH` is used by the pybind_library() bazel rule
RUN export PYTHON_BIN_PATH=$(which python)
RUN apt install --no-install-recommends -y python-numpy && rm -rf /var/lib/apt/lists/*;

# Install Renode test dependencies
RUN pip install --no-cache-dir pyyaml requests psutil robotframework==4.0.1

COPY ci/*.sh /install/
RUN /install/install_bazel.sh
RUN /install/install_buildifier.sh
