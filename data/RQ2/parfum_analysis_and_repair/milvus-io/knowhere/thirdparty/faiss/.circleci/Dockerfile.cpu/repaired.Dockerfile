FROM cimg/base:stable-20.04

# Install python3, swig, and MKL.
RUN sudo apt-get update && \
 sudo apt-get install --no-install-recommends -y python3-dev python3-pip swig libmkl-dev && rm -rf /var/lib/apt/lists/*;

# Install recent CMake.
RUN wget -nv -O - https://github.com/Kitware/CMake/releases/download/v3.17.1/cmake-3.17.1-Linux-x86_64.tar.gz | sudo tar xzf - --strip-components=1 -C /usr

# Install numpy/scipy/pytorch for python tests.
RUN pip3 install --no-cache-dir numpy scipy torch
