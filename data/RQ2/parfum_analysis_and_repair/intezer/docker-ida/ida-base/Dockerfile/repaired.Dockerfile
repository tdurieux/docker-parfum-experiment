# This is the foundation for all language-stack images (see: https://hub.docker.com/_/buildpack-deps/)
FROM buildpack-deps

# Add 32 bit architecture support for IDA
RUN dpkg --add-architecture i386 && apt-get -y update

# Replace the python version in the original image with a 32-bit version, so when we install external libraries -
# IDAPython (32bit) could import them
RUN apt-get -y --no-install-recommends install python2.7-minimal:i386 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python2.7:i386 && rm -rf /var/lib/apt/lists/*;
# Create a symlink for python for convenience (instead of typing python2.7)
RUN link /usr/bin/python2.7 /usr/bin/python

# Install necessary libraries for IDA and IDAPython to work
RUN apt-get -y --no-install-recommends install --fix-missing \
    lib32gcc1 \
    libc6-i686:i386 \
    libfontconfig:i386 \
    libfreetype6:i386 \
    libglib2.0-0:i386 \
    libpython2.7:i386 \
    libsm6:i386 \
    libssl-dev:i386 \
    libstdc++6:i386 \
    libxext6:i386 \
    libxrender1:i386 \
    lsb-core \
    python-dev && rm -rf /var/lib/apt/lists/*;

RUN wget https://security.debian.org/pool/updates/main/o/openssl/libssl0.9.8_0.9.8o-4squeeze14_i386.deb -P /installation
RUN dpkg -i /installation/libssl0.9.8_0.9.8o-4squeeze14_i386.deb

# Install pip for python 2.7
RUN apt-get -y --no-install-recommends install python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip2 install --no-cache-dir --upgrade pip