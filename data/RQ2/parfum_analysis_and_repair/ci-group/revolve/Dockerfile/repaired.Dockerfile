FROM cigroup/gazebo:gazebo10-revolve

# Dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
                       build-essential \
                       cmake \
                       git \
                       libgsl0-dev \
                       python3-pip \
                       libyaml-cpp-dev \
                       libcairo2-dev \
                       graphviz \
                       libeigen3-dev \
                       libnlopt-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD . /revolve
RUN /revolve/docker/build_revolve.sh
