FROM ubuntu:16.04
# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y apt-utils git \

    cmake libboost-dev libboost-program-options-dev libboost-math-dev libboost-log-dev libboost-system-dev libboost-timer-dev build-essential \

    python3 python3-pip \

    dpkg && rm -rf /var/lib/apt/lists/*;

# Install S3M
RUN mkdir -p /S3M
ADD . /S3M
WORKDIR /S3M
# Compile C++ code
RUN mkdir build
WORKDIR build
RUN cmake -DBUILD_LINUX_PACKAGES=ON ../code/cpp
RUN make
# Remove build dependencies again
RUN apt-get purge -y libboost-dev libboost-program-options-dev libboost-math-dev libboost-log-dev libboost-system-dev libboost-timer-dev build-essential && apt-get autoremove -y
# Install debian package
RUN apt install --no-install-recommends -y /S3M/build/packages/s3m-master.deb && rm -rf /var/lib/apt/lists/*;

# Cleanup to reduce docker image size
RUN rm -rf /var/lib/apt/lists/*

# Preprocessing scripts are path sensitive
WORKDIR /S3M/code/python

# Setup python environment
RUN pip3 install --no-cache-dir -r requirements.txt
# Add analysis scripts to path
ENV PYTHONPATH="/S3M/code/python:/S3M/code/python/utils"
ENV PATH="/S3M/code/python:${PATH}"
