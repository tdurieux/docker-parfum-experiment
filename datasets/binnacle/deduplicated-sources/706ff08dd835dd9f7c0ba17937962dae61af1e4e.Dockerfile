FROM centos:6

RUN set -x \
    && yum install epel-release -y

RUN yum install -y \
    ant \
    boost-devel \
    bzip2-devel \
    cmake \
    curl \
    expect \
    gcc \
    gcc-c++ \
    git \
    gpg \
    java-1.8.0-openjdk  \
    java-1.8.0-openjdk-devel  \
    libacl-devel \ 
    libcap-devel \ 
    libffi \
    libuuid-devel \
    lsof \
    make \
    openssl-devel \
    pam-devel \
    pango-devel \
    R \
    rpmdevtools \
    rpmsign \
    rrdtool \
    sudo \
    wget \
    xml-commons-apis \
    zlib-devel \
    libuser-devel \
    valgrind

# update gcc for C++11 support
RUN wget http://people.centos.org/tru/devtools-2/devtools-2.repo -O /etc/yum.repos.d/devtools-2.repo
RUN yum install -y devtoolset-2-gcc devtoolset-2-binutils devtoolset-2-gcc-c++

# update environment to use new compiler
ENV PATH="/opt/rh/devtoolset-2/root/usr/bin:${PATH}"
ENV CC="/opt/rh/devtoolset-2/root/usr/bin/gcc"
ENV CXX="/opt/rh/devtoolset-2/root/usr/bin/c++"
ENV CPP="/opt/rh/devtoolset-2/root/usr/bin/cpp"

## run install-boost twice - boost exits 1 even though it has installed good enough for our uses.
## https://github.com/rstudio/rstudio/blob/master/vagrant/provision-primary-user.sh#L12-L15
COPY dependencies/common/install-boost /tmp/
RUN bash /tmp/install-boost || bash /tmp/install-boost

# install cmake
COPY package/linux/install-dependencies /tmp/
RUN bash /tmp/install-dependencies

# set github login from build argument if defined
ARG GITHUB_LOGIN
ENV RSTUDIO_GITHUB_LOGIN=$GITHUB_LOGIN

# install common dependencies
ENV RSTUDIO_DISABLE_CRASHPAD=1
RUN mkdir -p /opt/rstudio-tools/dependencies/common
COPY dependencies/common/* /opt/rstudio-tools/dependencies/common/
RUN cd /opt/rstudio-tools/dependencies/common && /bin/bash ./install-common

# create jenkins user, make sudo. try to keep this toward the bottom for less cache busting
ARG JENKINS_GID=999
ARG JENKINS_UID=999
RUN groupadd -g $JENKINS_GID jenkins && \
    useradd -m -d /var/lib/jenkins -u $JENKINS_UID -g jenkins jenkins && \
    echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
