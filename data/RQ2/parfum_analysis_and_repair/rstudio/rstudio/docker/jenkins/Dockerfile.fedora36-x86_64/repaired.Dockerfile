FROM fedora:36

ENV OPERATING_SYSTEM=fedora_36

ARG AWS_REGION=us-east-1

RUN dnf install -y \
    R \
    ant \
    boost-devel \
    bzip2-devel \
    clang-devel \
    curl \
    expect \
    fakeroot \
    fuse-libs \
    gcc \
    gcc-c++ \
    git \
    gpg1 \
    gtk3 \
    java-11-openjdk \
    java-11-openjdk-devel \
    jq \
    libXScrnSaver-devel \
    libXcursor-devel \
    libXrandr-devel \
    libacl-devel \
    libcap-devel \ 
    libcurl-devel \
    libffi \
    libuser-devel \
    libuuid-devel \
    llvm-devel \
    lsof \
    make \
    mesa-libGL-devel \
    ninja-build \
    openssl-devel \
    p7zip \
    p7zip-plugins \
    pam-devel \
    pango-devel \
    patchelf \
    postgresql-devel \
    procps \
    python2 \
    python3 \
    rpm-sign \
    rpmdevtools \
    sqlite-devel \
    sudo \
    valgrind \
    wget \
    xml-commons-apis \
    xorg-x11-server-Xvfb \
    zlib-devel

# ensure we use the java 11 compiler to build GWT
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk

# copy RStudio tools (needed so that our other dependency scripts can find it)
RUN mkdir -p /tools
COPY dependencies/tools/rstudio-tools.sh /tools/rstudio-tools.sh

RUN mkdir -p /opt/rstudio-tools/dependencies/tools
COPY dependencies/tools/rstudio-tools.sh /opt/rstudio-tools/dependencies/tools/rstudio-tools.sh

# run install-boost twice - boost exits 1 even though it has installed good enough for our uses.
# https://github.com/rstudio/rstudio/blob/master/vagrant/provision-primary-user.sh#L12-L15
COPY dependencies/common/install-boost /tmp/
RUN bash /tmp/install-boost || bash /tmp/install-boost

# install cmake
COPY package/linux/install-dependencies /tmp/
RUN bash /tmp/install-dependencies

# copy python2 to python so that it can be picked up by Google scripts
RUN cp /usr/bin/python2 /usr/bin/python

# install crashpad and its dependencies
COPY dependencies/common/install-crashpad /tmp/
RUN bash /tmp/install-crashpad rhel8

# copy common dependency installation scripts
RUN mkdir -p /opt/rstudio-tools/dependencies/common
COPY dependencies/common/ /opt/rstudio-tools/dependencies/common/

# copy panmirror project setup (so install-common can install needed deps)
RUN mkdir -p /opt/rstudio-tools/panmirror
COPY src/gwt/panmirror/src/editor/yarn.lock /opt/rstudio-tools/panmirror/
COPY src/gwt/panmirror/src/editor/package.json /opt/rstudio-tools/panmirror/

# install common dependencies
RUN cd /opt/rstudio-tools/dependencies/common && /bin/bash ./install-common fedora36

# cachebust for Quarto release
ADD https://quarto.org/docs/download/_download.json quarto_releases
RUN cd /opt/rstudio-tools/dependencies/common && /bin/bash ./install-quarto

# set github login from build argument if defined
ARG GITHUB_LOGIN
ENV RSTUDIO_GITHUB_LOGIN=$GITHUB_LOGIN

# remove any previous users with conflicting IDs
ARG JENKINS_GID=999
ARG JENKINS_UID=999
COPY docker/jenkins/*.sh /tmp/
RUN /tmp/clean-uid.sh $JENKINS_UID && \
    /tmp/clean-gid.sh $JENKINS_GID

# create jenkins user, make sudo. try to keep this toward the bottom for less cache busting
RUN groupadd -g $JENKINS_GID jenkins && \
    useradd -m -d /var/lib/jenkins -u $JENKINS_UID -g jenkins jenkins && \
    echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers