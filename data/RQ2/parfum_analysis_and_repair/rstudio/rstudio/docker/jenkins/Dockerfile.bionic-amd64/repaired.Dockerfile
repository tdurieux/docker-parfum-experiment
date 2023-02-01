FROM ubuntu:bionic

ENV OPERATING_SYSTEM=ubuntu_bionic

ARG AWS_REGION=us-east-1

# install needed packages. replace httpredir apt source with cloudfront
RUN set -x \
    && sed -i "s/archive.ubuntu.com/$AWS_REGION.ec2.archive.ubuntu.com/" /etc/apt/sources.list \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install --no-install-recommends -y gnupg1 \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0x51716619e084dab9 \
    && echo 'deb http://cran.rstudio.com/bin/linux/ubuntu bionic-cran35/' >> /etc/apt/sources.list \
    && apt-get update && rm -rf /var/lib/apt/lists/*;

# add ppa repository so we can install java 8 (not in any official repo for bionic)
RUN apt-get update \
  && apt-get install --no-install-recommends -y software-properties-common \
  && add-apt-repository ppa:openjdk-r/ppa && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install --no-install-recommends -y \
    ant \
    build-essential \
    clang \
    curl \
    debsigs \
    dpkg-sig \
    expect \
    fakeroot \
    git-core \
    jq \
    libattr1-dev \
    libacl1-dev \
    libbz2-dev \
    libcap-dev \
    libcurl4-openssl-dev \
    libfuse2 \
    libgtk-3-0 \
    libgl1-mesa-dev \
    libegl1-mesa \
    libpam-dev \
    libpango1.0-dev \
    libpq-dev \
    libsqlite3-dev \
    libuser1-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    lsof \
    ninja-build \
    openjdk-8-jdk \
    p7zip-full \
    pkg-config \
    python \
    r-base \
    sudo \
    unzip \
    uuid-dev \
    valgrind \
    wget \
    xvfb \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

# ensure we use the java 8 compiler
RUN update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

## build patchelf
RUN cd /tmp \
    && wget https://nixos.org/releases/patchelf/patchelf-0.9/patchelf-0.9.tar.gz \
    && tar xzvf patchelf-0.9.tar.gz \
    && cd patchelf-0.9 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install && rm patchelf-0.9.tar.gz

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
RUN /bin/bash /tmp/install-dependencies

# install crashpad and its dependencies
COPY dependencies/common/install-crashpad /tmp/
RUN bash /tmp/install-crashpad bionic

# copy common dependency installation scripts
RUN mkdir -p /opt/rstudio-tools/dependencies/common
COPY dependencies/common/ /opt/rstudio-tools/dependencies/common/

# copy panmirror project setup (so install-common can install needed deps)
RUN mkdir -p /opt/rstudio-tools/panmirror
COPY src/gwt/panmirror/src/editor/yarn.lock /opt/rstudio-tools/panmirror/
COPY src/gwt/panmirror/src/editor/package.json /opt/rstudio-tools/panmirror/

# install common dependencies
RUN cd /opt/rstudio-tools/dependencies/common && /bin/bash ./install-common bionic

# cachebust for Quarto release
ADD https://quarto.org/docs/download/_download.json quarto_releases
RUN cd /opt/rstudio-tools/dependencies/common && /bin/bash ./install-quarto

# set github login from build argument if defined
ARG GITHUB_LOGIN
ENV RSTUDIO_GITHUB_LOGIN=$GITHUB_LOGIN

# create jenkins user, make sudo. try to keep this toward the bottom for less cache busting
ARG JENKINS_GID=999
ARG JENKINS_UID=999
RUN groupadd -g $JENKINS_GID jenkins && \
    useradd -m -d /var/lib/jenkins -u $JENKINS_UID -g jenkins jenkins && \
    echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

