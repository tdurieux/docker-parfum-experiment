# Set the base image to Ubuntu
FROM ubuntu:16.04

MAINTAINER Jeremy Magland

RUN echo "clear"
RUN apt-get update

# Install qt5
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-add-repository ppa:ubuntu-sdk-team/ppa
RUN apt-get update
RUN apt-get install --no-install-recommends -y qtdeclarative5-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y qt5-default qtbase5-dev qtscript5-dev make g++ && rm -rf /var/lib/apt/lists/*;

# Install nodejs and npm
RUN apt-get install --no-install-recommends -y nodejs npm && rm -rf /var/lib/apt/lists/*;

# Install git
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# Install fftw
RUN apt-get install --no-install-recommends -y libfftw3-dev && rm -rf /var/lib/apt/lists/*;

# Install octave
RUN apt-get install --no-install-recommends -y octave && rm -rf /var/lib/apt/lists/*;
