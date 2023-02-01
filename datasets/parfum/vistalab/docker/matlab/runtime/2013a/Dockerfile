# Download and install Matlab Compiler Runtime v8.1 (2013a)
#
# This docker file will configure an environment into which the Matlab compiler
# runtime will be installed and in which stand-alone matlab routines (such as
# those created with Matlab's deploytool) can be executed.
#
# See http://www.mathworks.com/products/compiler/mcr/ for more info.

FROM ubuntu-debootstrap:trusty

# Install the MCR dependencies and some things we'll need and download the MCR
# from Mathworks - silently install it
RUN apt-get -qq update && apt-get -qq install -y unzip xorg wget curl && \
    mkdir /opt/mcr && \
    mkdir /mcr-install && \
    cd /mcr-install && \
    wget -nv http://www.mathworks.com/supportfiles/MCR_Runtime/R2013a/MCR_R2013a_glnxa64_installer.zip && \
    unzip MCR_R2013a_glnxa64_installer.zip && \
    ./install -destinationFolder /opt/mcr -agreeToLicense yes -mode silent && \
    cd / && \
    rm -rf /mcr-install

# Configure environment variables for MCR
ENV LD_LIBRARY_PATH /opt/mcr/v81/runtime/glnxa64:/opt/mcr/v81/bin/glnxa64:/opt/mcr/v81/sys/os/glnxa64:/opt/mcr/v81/sys/java/jre/glnxa64/jre/lib/amd64/native_threads:/opt/mcr/v81/sys/java/jre/glnxa64/jre/lib/amd64/server:/opt/mcr/v81/sys/java/jre/glnxa64/jre/lib/amd64
ENV XAPPLRESDIR /opt/mcr/v81/X11/app-defaults

