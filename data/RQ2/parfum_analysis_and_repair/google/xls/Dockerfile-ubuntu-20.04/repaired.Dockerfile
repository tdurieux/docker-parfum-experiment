# Download base image ubuntu 20.04
FROM ubuntu:20.04

# LABEL about the custom image
LABEL version="0.1"
LABEL description="Docker Image for Building/Testing XLS on Ubuntu 20.04 x86-64"

# Update package info
RUN apt-get update -y

# Install Bazel
RUN apt-get install --no-install-recommends -y curl gnupg && \
 curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --batch --dearmor > bazel.gpg && \
mv bazel.gpg /etc/apt/trusted.gpg.d/ && \
echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list && \
apt-get update -y && apt-get install --no-install-recommends -y bazel && rm -rf /var/lib/apt/lists/*;

# Install dependencies
RUN apt-get -y --no-install-recommends install python3-distutils python3-dev python-is-python3 libtinfo5 && rm -rf /var/lib/apt/lists/*;

# Install development tools
RUN apt-get install --no-install-recommends -y git vim && rm -rf /var/lib/apt/lists/*;

RUN useradd -m xls-developer
USER xls-developer

# Map the project contents in.
ADD --chown=xls-developer . /home/xls-developer/xls/
WORKDIR /home/xls-developer/xls/


# Build everything (opt)
RUN bazel build -c opt ...

# Test everything (opt)
RUN bazel test -c opt ...
