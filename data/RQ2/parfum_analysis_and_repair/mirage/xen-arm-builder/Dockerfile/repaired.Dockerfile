FROM debian:stretch
MAINTAINER Richard Mortier <mort@cantab.net>

RUN apt-get update                              \
    && apt-get -y upgrade \
    && apt-get install --no-install-recommends -y \
         bc \
         build-essential \
         curl \
         device-tree-compiler \
         dosfstools \
         gcc-arm-linux-gnueabi \
         git \
         man \
         u-boot-tools && rm -rf /var/lib/apt/lists/*;

VOLUME ["/cwd"]
WORKDIR /cwd

ENTRYPOINT ["bash"]
