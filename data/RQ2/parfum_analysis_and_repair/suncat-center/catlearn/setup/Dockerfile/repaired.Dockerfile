FROM ubuntu:latest

# Set environment variables.
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Add some descriptive labels.
LABEL Description="This image is used to setup the CatLearn environment." Version="0.4.0"

# Install various python versions.
RUN apt-get update && apt-get install --no-install-recommends -y \
    python2.7 \
    python3 \
    python-pip \
    python3-pip && rm -rf /var/lib/apt/lists/*;

# Install additional python packages.
COPY requirements.txt .
RUN pip2 install --no-cache-dir --upgrade pip
RUN apt-get remove -y python-pip
RUN pip2 install --no-cache-dir --upgrade -r requirements.txt; pip2 install --no-cache-dir asap3
RUN pip3 install --no-cache-dir --upgrade pip
RUN apt-get remove -y python3-pip
RUN pip3 install --no-cache-dir --upgrade -r requirements.txt; pip3 install --no-cache-dir asap3

RUN apt-get update

# Install java.
RUN apt-get -y --no-install-recommends install software-properties-common && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt update && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
    apt -y --no-install-recommends install oracle-java8-installer && \
    apt -y --no-install-recommends install oracle-java8-set-default && rm -rf /var/lib/apt/lists/*;

# Insatll some additional functionality.
RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    vim && rm -rf /var/lib/apt/lists/*;
