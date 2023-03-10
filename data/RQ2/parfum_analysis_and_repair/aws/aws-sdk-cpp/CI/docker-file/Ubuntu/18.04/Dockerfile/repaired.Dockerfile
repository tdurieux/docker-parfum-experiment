# Using official ubuntu docker image
FROM ubuntu:18.04

# Install git, zip, python-pip, cmake, g++, zlib, libssl, libcurl, java, maven via apt
RUN apt update && \
    apt upgrade -y && \
    apt install --no-install-recommends -y git zip wget python-pip python3 python3-pip cmake g++ zlib1g-dev libssl-dev libcurl4-openssl-dev openjdk-8-jdk doxygen ninja-build && rm -rf /var/lib/apt/lists/*;

# Install maven
RUN apt install --no-install-recommends -y maven && rm -rf /var/lib/apt/lists/*;

# Install awscli
RUN pip install --no-cache-dir awscli --upgrade

# Install boto3
RUN pip3 install --no-cache-dir boto3 --upgrade

# Download and install Android NDK
RUN wget https://dl.google.com/android/repository/android-ndk-r19c-linux-x86_64.zip && \
    unzip android-ndk-r19c-linux-x86_64.zip && \
    mv android-ndk-r19c /opt && \
    rm android-ndk-r19c-linux-x86_64.zip
ENV ANDROID_NDK /opt/android-ndk-r19c
