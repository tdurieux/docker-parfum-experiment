FROM sophistsolutionsinc/stroika-buildvm-ubuntu2110-small

# Get latest packages system, so can do installs
RUN apt-get update

# Needed to install lsb-release since Ubuntu 21.04
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Just to echo information in regression test output
RUN apt-get install --no-install-recommends -y lsb-release && rm -rf /var/lib/apt/lists/*;

#install the latest (C++17 compat) g++ compilers
RUN apt-get install --no-install-recommends -y g++-8 g++-9 g++-10 g++-11 && rm -rf /var/lib/apt/lists/*;

# For some reason not installed on ubuntu 21.04 otherwise
RUN apt-get install --no-install-recommends -y libz.a && rm -rf /var/lib/apt/lists/*;

# For reasons which elude me, installing libc++-N removes all the other
# https://askubuntu.com/questions/1227092/how-can-i-install-multiple-versions-of-llvm-libc-on-the-same-computer-at-the-s

#install the latest (C++17 compat) clang compilers (and libs)
RUN apt-get install --no-install-recommends -y clang++-10 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y clang++-11 && apt-get install --no-install-recommends -y libc++-11-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y clang++-12 && apt-get install --no-install-recommends -y libc++-12-dev && rm -rf /var/lib/apt/lists/*;

# note libunwind-13-dev dependend on by clang++13, it appears
RUN apt-get install --no-install-recommends -y clang++-13 && apt-get install --no-install-recommends -y libunwind-13-dev && apt-get install --no-install-recommends -y libc++-13-dev libc++abi-13-dev && rm -rf /var/lib/apt/lists/*;

#Only needed to run with valgrind regtests
RUN apt-get install --no-install-recommends -y valgrind && rm -rf /var/lib/apt/lists/*;

# Cross-compile tests for ARM (iputils-ping is how we detect if machine exists to run regtests on)
RUN apt-get install --no-install-recommends -y g++-9-arm-linux-gnueabihf g++-10-arm-linux-gnueabihf g++-11-arm-linux-gnueabihf iputils-ping && rm -rf /var/lib/apt/lists/*;
