FROM nisar/base:latest

MAINTAINER Piyush Agram <piyush.agram@jpl.nasa.gov>

# Set an encoding to make things work smoothly.
ENV LANG en_US.UTF-8

# Install dependencies for ISCE developement
COPY requirements.txt.dev /tmp/requirements.txt
COPY gcc7.tar.gz /tmp/gcc7.tar.gz
RUN set -ex \
 && sudo yum update -y \
 && sudo yum install -y \
      cuda-libraries-dev-$CUDA_PKG_VERSION \
      cuda-nvml-dev-$CUDA_PKG_VERSION \
      cuda-minimal-build-$CUDA_PKG_VERSION \
      cuda-command-line-tools-$CUDA_PKG_VERSION \
 && sudo yum install -y \
      devtoolset-7-make \
      devtoolset-7-binutils \
 && sudo yum clean all \
 && sudo rm -rf /var/cache/yum \
 && cd /opt \
 && sudo tar xvfz /tmp/gcc7.tar.gz \
 && sudo ln -sf /opt/gcc7/bin/gcc /opt/gcc7/bin/cc \
 && export PATH=/opt/conda/bin:$PATH \
 && sudo conda install --yes --file /tmp/requirements.txt \
 && sudo conda clean -tipsy \
 && sudo rm -rf /opt/conda/pkgs \
 && sudo rm -rf /var/cache/yum \
 && sudo rm -rf /tmp/gcc7.tar.gz \
 && sudo rm /tmp/requirements.txt

# Add a file for users to source to activate the `conda`
# environment `root` and the devtoolset compiler. Also
# add a file that wraps that for use with the `ENTRYPOINT`.
COPY entrypoint_source.dev /opt/docker/bin/entrypoint_source