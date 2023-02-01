FROM ubuntu:trusty-20191217

# Update binutils, g++, gcc
RUN apt-get update -y && \
    apt-get install --no-install-recommends build-essential software-properties-common -y && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends binutils-2.26 && \
    apt-get install --no-install-recommends build-essential software-properties-common -y && \
    apt-get update && \
    apt-get install --no-install-recommends gcc-9 g++-9 -y && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9 && \
    update-alternatives --config gcc && rm -rf /var/lib/apt/lists/*;
ENV PATH=/usr/lib/binutils-2.26/bin:$PATH

# Install libs & tools
ENV DEPOT_TOOLS=/usr/depot_tools
ENV PATH=$DEPOT_TOOLS:$PATH
RUN apt-get install --no-install-recommends git python wget -y && \
    apt-get install --no-install-recommends fontconfig libfontconfig1-dev libglu1-mesa-dev libxrandr-dev libdbus-1-dev curl zip -y && \
    git clone 'https://chromium.googlesource.com/chromium/tools/depot_tools.git' $DEPOT_TOOLS && rm -rf /var/lib/apt/lists/*;

# Install Java
ENV JAVA_HOME=/usr/java/11
ENV PATH=$JAVA_HOME/bin:$PATH
RUN JAVA_URL=https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.tar.gz && \
    JAVA_ARCHIVE=/tmp/jdk.tar.gz && \
    JAVA_BASE=/usr/java/ && \
    wget $JAVA_URL --output-document $JAVA_ARCHIVE && \
    mkdir -p $JAVA_BASE && \
    tar -xzf $JAVA_ARCHIVE --directory $JAVA_BASE && \ 
    find $JAVA_BASE -type d -maxdepth 1 -name "amazon-corretto-11*linux-x64" -exec mv {} $JAVA_HOME \; && \
    rm $JAVA_ARCHIVE
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8
ENV JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF
