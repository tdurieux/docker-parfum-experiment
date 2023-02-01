FROM ubuntu:xenial

# Updating system and installing dependencies.
RUN apt-get update && apt-get install --no-install-recommends -y cmake gcc gdb git vim emacs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libeigen3-dev libgoogle-glog-dev libgflags-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y freeglut3-dev xorg-dev libglu1-mesa-dev && rm -rf /var/lib/apt/lists/*;

# Create directory structure and clone from git.
RUN git clone https://github.com/HJReachability/ilqgames
WORKDIR /ilqgames

# Compile.
RUN mkdir build
WORKDIR /ilqgames/build
RUN cmake ..
RUN make -j4
WORKDIR /ilqgames
