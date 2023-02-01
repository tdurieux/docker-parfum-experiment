FROM ubuntu:latest
LABEL maintainer="<sra-tools@ncbi.nlm.nih.gov>"
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y --no-install-recommends install build-essential doxygen && \

    apt-get -y --no-install-recommends install apt-transport-https ca-certificates curl software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get -y --no-install-recommends install docker-ce && \

    make -v && \
    echo "Doxygen $(doxygen -v)" && \
    docker -v && rm -rf /var/lib/apt/lists/*;

# bake and install googletest
RUN apt-get -y --no-install-recommends install cmake && \
    git clone https://github.com/abseil/googletest.git home/googletest && \
    mkdir home/googletest/build && \
    cd home/googletest/build && \
    cmake .. && \
    make install && rm -rf /var/lib/apt/lists/*;
