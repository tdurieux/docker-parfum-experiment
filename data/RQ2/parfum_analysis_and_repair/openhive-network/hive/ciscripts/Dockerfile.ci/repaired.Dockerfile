# for building the consensus_node/fat_node images, set CI_REGISTRY_IMAGE to the
# project's registry (e.g. registry.gitlab.syncad.com/hive/hive)
ARG CI_REGISTRY_IMAGE
ARG RUNTIME_IMAGE_TAG=:latest

FROM ubuntu:18.04 AS runtime
ENV LANG=en_US.UTF-8

RUN apt-get update && apt-get install --no-install-recommends -y language-pack-en && apt-get install --no-install-recommends -y libsnappy1v5 libreadline7 && apt-get clean && rm -r /var/lib/apt/lists/*

###################################
FROM runtime AS builder-tester-base

RUN apt-get update && \
    apt-get install --no-install-recommends -y git python3 build-essential gir1.2-glib-2.0 libgirepository-1.0-1 libglib2.0-0 libglib2.0-data libicu60 libxml2 python3-distutils python3-lib2to3 python3-pkg-resources shared-mime-info xdg-user-dirs && \
    apt-get clean && rm -r /var/lib/apt/lists/*

###################################
FROM builder-tester-base AS builder

RUN apt-get update && \
    apt-get install --no-install-recommends -y autoconf automake cmake g++ git libbz2-dev libsnappy-dev libssl-dev libtool make pkg-config python3-jinja2 libboost-chrono-dev libboost-context-dev libboost-coroutine-dev libboost-date-time-dev libboost-filesystem-dev libboost-iostreams-dev libboost-locale-dev libboost-program-options-dev libboost-serialization-dev libboost-signals-dev libboost-system-dev libboost-test-dev libboost-thread-dev doxygen libncurses5-dev libreadline-dev perl ninja-build && \
    apt-get clean && rm -r /var/lib/apt/lists/*

###################################
FROM builder-tester-base AS test

RUN apt-get update && \
    DEBIAN_FRONTEND=noniteractive apt-get --no-install-recommends install -y screen python3-pip python3-dateutil tzdata python3-junit.xml && \
    apt-get clean && rm -r /var/lib/apt/lists/* && \
    pip3 install --no-cache-dir -U secp256k1prp
# the above will leave the timezone in UTC, if you want run:
#    ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

#####################################################################
FROM $CI_REGISTRY_IMAGE/runtime$RUNTIME_IMAGE_TAG AS consensus_node

ARG TRACKED_ACCOUNT_NAME
ENV TRACKED_ACCOUNT_NAME=${TRACKED_ACCOUNT_NAME}
ARG USE_PUBLIC_BLOCKLOG
ENV USE_PUBLIC_BLOCKLOG=${USE_PUBLIC_BLOCKLOG}
ENV install_base_dir="/usr/local/hive"

# rpc
EXPOSE 8090

# p2p
EXPOSE 2001

WORKDIR "${install_base_dir}/consensus"
COPY consensus_build/install-root/ consensus_build/hived.run ./
COPY consensus_build/config-for-docker.ini datadir/config.ini
RUN chmod 755 hived.run

CMD "${install_base_dir}/consensus/hived.run"

#####################################################################
FROM $CI_REGISTRY_IMAGE/runtime$RUNTIME_IMAGE_TAG AS fat_node

ARG TRACKED_ACCOUNT_NAME
ENV TRACKED_ACCOUNT_NAME=${TRACKED_ACCOUNT_NAME}
ARG USE_PUBLIC_BLOCKLOG
ENV USE_PUBLIC_BLOCKLOG=${USE_PUBLIC_BLOCKLOG}
ENV install_base_dir="/usr/local/hive"

# rpc
EXPOSE 8090

# p2p
EXPOSE 2001

WORKDIR "${install_base_dir}/fat-node"
COPY fat_build/install-root/ fat_build/hived.run ./
COPY fat_build/config-for-docker.ini datadir/config.ini
RUN chmod 755 hived.run

CMD "${install_base_dir}/fat-node/hived.run"
