# To push a new version:
# TODO(klimek): This currently only works on an OS that supports vsyscall, which
# ubuntu and debian machines do not; once a docker image of centos without
# vsyscall use is available, use that instead. For now, the best way to run this
# is to run it from a centos7 machine.
# 0. Copy this file and the corresponding shell script to the centos7 machine.
# 1. Download tensorrt from
#    https://developer.nvidia.com/nvidia-tensorrt-5x-download
#    and copy it into /tmp.
# 2. $ ./Dockerfile.rbe.cuda10.1-cudnn7-centos.sh
# 3. $ docker push gcr.io/tensorflow-testing/nosla-cuda10.1-cudnn7-centos6
#
# We can't currently build this Dockerfile directly:
# tensorrt for centos is only availble via a authenticated download link from
# nvidia, and it's larger than citc's max file size.
# To work around this, we create a Docker environment in /tmp to build the
# image from in a shell script (2).

FROM nvidia/cuda:10.1-cudnn7-devel-centos6
LABEL maintainer="Amit Patankar <amitpatankar@google.com>"

# Install yum packages required to build tensorflow.
COPY install/*.sh /install/
RUN bash install/install_yum_packages.sh

# TODO(klimek): Once nvidia provides a way to install tensorrt from within
# docker, switch to that. Until then, we copy the tensorrt rpm into the docker
# environment.
ADD tensorrt.rpm tensorrt.rpm
RUN rpm -ihv tensorrt.rpm && \
    yum install -y --nogpgcheck tensorrt && \
    rm -f tensorrt.rpm && rm -rf /var/cache/yum

# Enable devtoolset-7 and python27 in the docker image.
env PATH="/opt/rh/python27/root/usr/bin:/opt/rh/devtoolset-7/root/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
    LD_LIBRARY_PATH="/opt/rh/python27/root/usr/lib64:/opt/rh/devtoolset-7/root/usr/lib64:/opt/rh/devtoolset-7/root/usr/lib:/opt/rh/devtoolset-7/root/usr/lib64/dyninst:/opt/rh/devtoolset-7/root/usr/lib/dyninst:/opt/rh/devtoolset-7/root/usr/lib64:/opt/rh/devtoolset-7/root/usr/lib:/usr/local/nvidia/lib:/usr/local/nvidia/lib64" \
    PCP_DIR="/opt/rh/devtoolset-7/root" \
    PERL5LIB="/opt/rh/devtoolset-7/root//usr/lib64/perl5/vendor_perl:/opt/rh/devtoolset-7/root/usr/lib/perl5:/opt/rh/devtoolset-7/root//usr/share/perl5/vendor_perl" \
    PKG_CONFIG_PATH="/opt/rh/python27/root/usr/lib64/pkgconfig/"

# Install python3.6 and pip packages needed to build tensorflow.
RUN bash install/install_centos_python36.sh
RUN bash install/install_centos_pip_packages.sh

# Install a /usr/bin/python3 link.
# centos by default does not provide links, and instead relies on paths into
# /opt/ to switch to alternative configurations. For bazel remote builds,
# the python path between the local machine running bazel and the remote setup
# must be the same.
RUN update-alternatives --install /usr/bin/python2 python2 /opt/rh/python27/root/usr/bin/python2.7 0
RUN update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.6 0

# Install a ubuntu-compatible openjdk link so that ubuntu JAVA_HOME works
# for this image.
# TODO(klimek): Figure out a way to specify a different remote java path from
# the local one.
RUN ln -s /usr/lib/jvm/java /usr/lib/jvm/java-8-openjdk-amd64
