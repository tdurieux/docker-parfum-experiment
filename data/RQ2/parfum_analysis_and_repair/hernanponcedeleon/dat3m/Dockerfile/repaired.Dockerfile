#Download base image ubuntu 20.04
FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository ppa:sosy-lab/benchmarking && \
    apt-get install --no-install-recommends -y git && \
    apt-get install --no-install-recommends -y lsb-release && \
    apt-get install --no-install-recommends -y sudo && \
    apt-get install --no-install-recommends -y wget && \
    apt-get install --no-install-recommends -y gnupg && \
    apt-get install --no-install-recommends -y maven && \
    apt-get install --no-install-recommends -y curl && \
    apt-get install --no-install-recommends -y build-essential && \
    apt-get install --no-install-recommends -y libcap-dev && \
    apt-get install --no-install-recommends -y cmake && \
    apt-get install --no-install-recommends -y udev && \
    apt-get install --no-install-recommends -y graphviz && \
    apt-get install --no-install-recommends -y benchexec && rm -rf /var/lib/apt/lists/*;

# Install SMACK
RUN cd home && \
    git clone https://github.com/smackers/smack.git && \
    cd smack && \
    sed -i 's/TEST_SMACK=1/TEST_SMACK=0/' bin/build.sh && \
    bash bin/build.sh

# Install Dat3M
RUN cd home && \
    git clone --branch development https://github.com/hernanponcedeleon/Dat3M.git && \
    cd Dat3M && \
    chmod 755 Dartagnan-SVCOMP.sh && \
    mvn clean install -DskipTests

# symlink for clang
RUN ln -s clang-12 /usr/bin/clang

ENV DAT3M_HOME=/home/Dat3M
ENV DAT3M_OUTPUT=$DAT3M_HOME/output
ENV CFLAGS="-I$DAT3M_HOME/include"
ENV SMACK_FLAGS="-q -t --no-memory-splitting"
