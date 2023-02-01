FROM opensuse:42.3

# needed to build RPMs
RUN zypper --non-interactive addrepo http://download.opensuse.org/repositories/systemsmanagement:wbem:deps/openSUSE_Leap_42.3/systemsmanagement:wbem:deps.repo

# refresh repos and install required packages
RUN zypper --non-interactive --gpg-auto-import-keys refresh && \
    zypper --non-interactive install -y \
    ant \
    boost-devel \
    curl \
    expect \
    fakeroot \
    gcc \
    gcc-c++ \
    git \
    java-1_8_0-openjdk  \
    libacl-devel \
    libattr-devel \
    libcap-devel \
    libuser-devel \
    libuuid-devel \
    libXcursor-devel \
    libXrandr-devel \
    lsof \
    make \
    openssl-devel \
    pam-devel \
    pango-devel \
    python \
    R \
    rpm-build \
    sudo \
    tar \
    unzip \
    valgrind \
    wget \
    xml-commons-apis \
    zlib-devel \
    libuser-devel

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

# install Qt SDK
COPY dependencies/linux/install-qt-sdk /tmp/
RUN mkdir -p /opt/RStudio-QtSDK && \
    export QT_VERSION=5.10.1 && \
    export QT_SDK_DIR=/opt/RStudio-QtSDK/Qt${QT_VERSION} && \
    export QT_SDK_CUSTOM=QtSDK-${QT_VERSION}-x86_64.tar.gz && \
    /tmp/install-qt-sdk

# create jenkins user, make sudo. try to keep this toward the bottom for less cache busting
ARG JENKINS_GID=999
ARG JENKINS_UID=999
RUN groupadd -g $JENKINS_GID jenkins && \
    useradd -m -d /var/lib/jenkins -u $JENKINS_UID -g jenkins jenkins && \
    echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
