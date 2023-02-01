FROM ubuntu:18.04

# Update image
RUN apt-get update && apt-get upgrade -y

# Enable CMake PPA
RUN apt-get install --no-install-recommends -y apt-transport-https ca-certificates gnupg software-properties-common wget && rm -rf /var/lib/apt/lists/*;
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add -
RUN apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' && apt-get update

# Install required dependencies
RUN apt-get install --no-install-recommends -y build-essential devscripts cmake g++-8 qt5-default libqt5widgets5 libqt5svg5 libqt5svg5-dev p7zip-full wget libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;

# OpenSSL 1.1.1m
RUN wget https://www.openssl.org/source/openssl-1.1.1m.tar.gz && tar xf openssl-1.1.1m.tar.gz && rm openssl-1.1.1m.tar.gz
RUN export CC=gcc-8; export CXX=gcc-8; cd openssl-1.1.1m; ./config --static -static && make -j$(nproc) && make install_sw

# Download nlohmann-json and doctest from GitHub
ADD https://github.com/nlohmann/json/releases/download/v3.7.3/json.hpp /usr/include/nlohmann/json.hpp
ADD https://raw.githubusercontent.com/onqtam/doctest/2.3.6/doctest/doctest.h /usr/include/doctest/doctest.h
RUN chmod 644 /usr/include/nlohmann/json.hpp /usr/include/doctest/doctest.h

RUN apt-get install --no-install-recommends -y nano && rm -rf /var/lib/apt/lists/*;

# Cleanup
RUN rm -rf /var/lib/apt/lists/*

# Let's not run as root
RUN useradd -m builduser && passwd -d builduser

USER builduser
