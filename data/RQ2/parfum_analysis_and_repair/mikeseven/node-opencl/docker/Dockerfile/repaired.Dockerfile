FROM ubuntu:14.04
MAINTAINER Dan Liew <daniel.liew@imperial.ac.uk>, Ioweb <contact@ioweb.fr>

##### INSTRUCTIONS
#
# You need to download AMD APP SDK and put it in the same folder as the Dockerfile
# with the name :
# amd-app-sdk.tar.bz2
#
#####

RUN apt-get update
RUN apt-get -y --no-install-recommends install software-properties-common python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install gcc g++ gdb && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install cmake mercurial git make subversion && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python python-dev python-pip vim wget openssh-server && rm -rf /var/lib/apt/lists/*;

RUN \
  cd /tmp && \
  wget https://nodejs.org/dist/node-latest.tar.gz && \
  tar xvzf node-latest.tar.gz && \
  rm -f node-latest.tar.gz && \
  cd node-v* && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
  CXX="g++ -Wno-unused-local-typedefs" make && \
  CXX="g++ -Wno-unused-local-typedefs" make install && \
  cd /tmp && \
  rm -rf /tmp/node-v* && \
  npm install -g npm && \
  echo -e '\n# Node.js\nexport PATH="node_modules/.bin:$PATH"' >> /root/.bashrc && npm cache clean --force;

WORKDIR /root

ADD amd-app-sdk.tar.bz2 /tmp

# Finally we can install it
RUN /tmp/AMD-APP-SDK-*.sh -- --acceptEULA 'yes' -s

# Remove installation files
#RUN rm /tmp/AMD-APP-SDK-*.sh && rm -rf /tmp/AMDAPPSDK-*

# Remove the samples. Keep the OpenCL ones
RUN rm -rf /opt/AMDAPPSDK-*/samples/{aparapi,bolt,opencv}

# Put the includes and library where they are expected to be
RUN mkdir -p /usr/lib64/OpenCL/vendors/amd/
RUN mv /opt/AMD*/lib/x86_64/* /usr/lib64/OpenCL/vendors/amd/
RUN echo "/usr/lib64/OpenCL/vendors/amd" > /etc/ld.so.conf.d/opencl-vendor-amd.conf
RUN ldconfig
RUN ln -s /usr/lib64/OpenCL/vendors/amd/libOpenCL.so /usr/lib64/libOpenCL.so
RUN cp /etc/OpenCL/amdocl64.icd /etc/OpenCL/vendors
RUN ln -s /opt/AMDAPPSDK-*/include/CL /usr/include/

# Provide easy access to root if needed
RUN echo "root:root" | chpasswd

# NodeJS
RUN npm install -g mocha node-gyp eslint && npm cache clean --force;

# Add a non root user
RUN useradd -m aasdk
USER aasdk
WORKDIR /home/aasdk


