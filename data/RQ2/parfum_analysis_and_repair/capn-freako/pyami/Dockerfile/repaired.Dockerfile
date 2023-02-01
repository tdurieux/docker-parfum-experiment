FROM ubuntu:latest

# Install Python and Boost.
RUN \
  apt-get update \
  && apt-get install --no-install-recommends -y python-pip python3-pip python3-dev libboost-all-dev git nano vim gdb \
  && apt-get install --no-install-recommends -y build-essential cppcheck clang-tidy clang g++ g++-multilib gcc gcc-multilib \
  && pip3 install --no-cache-dir tox black numpy && rm -rf /var/lib/apt/lists/*;

# Define working directory.
WORKDIR /data

ENV IBISAMI_ROOT=/data/PyAMI/ibisami
ENV BOOST_ROOT=/usr/include/boost
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Define default command.
CMD ["bash"]