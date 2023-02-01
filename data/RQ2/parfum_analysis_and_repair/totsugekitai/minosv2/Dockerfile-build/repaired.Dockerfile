FROM ubuntu:18.04

WORKDIR /minOSv2

RUN apt-get update && apt-get install --no-install-recommends -y \
    make \
    gcc-multilib \
    clang \
    lld && rm -rf /var/lib/apt/lists/*;

RUN mkdir common kernel
COPY common/ ./common/
COPY kernel/ ./kernel/
COPY Makefile ./

RUN make kernel