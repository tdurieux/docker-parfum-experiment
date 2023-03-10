FROM scratch
ADD ubuntu-xenial-core-cloudimg-amd64-root.tar.gz /
# a few minor docker-specific tweaks
# see https://github.com/docker/docker/blob/9a9fc01af8fb5d98b8eec0740716226fadb3735c/contrib/mkimage/debootstrap
RUN set -xe; \
    \
# https://github.com/docker/docker/blob/9a9fc01af8fb5d98b8eec0740716226fadb3735c/contrib/mkimage/debootstrap#L40-L48
    echo '#!/bin/sh' > /usr/sbin/policy-rc.d; \
    echo 'exit 101' >> /usr/sbin/policy-rc.d; \
    chmod +x /usr/sbin/policy-rc.d; \
    \
# https://github.com/docker/docker/blob/9a9fc01af8fb5d98b8eec0740716226fadb3735c/contrib/mkimage/debootstrap#L54-L56
    dpkg-divert --local --rename --add /sbin/initctl; \
    cp -a /usr/sbin/policy-rc.d /sbin/initctl; \
    sed -i 's/^exit.*/exit 0/' /sbin/initctl; \
    \
# https://github.com/docker/docker/blob/9a9fc01af8fb5d98b8eec0740716226fadb3735c/contrib/mkimage/debootstrap#L71-L78
    echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup; \
    \
# https://github.com/docker/docker/blob/9a9fc01af8fb5d98b8eec0740716226fadb3735c/contrib/mkimage/debootstrap#L85-L105
    echo 'DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' > /etc/apt/apt.conf.d/docker-clean; \
    echo 'APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' >> /etc/apt/apt.conf.d/docker-clean; \
    echo 'Dir::Cache::pkgcache ""; Dir::Cache::srcpkgcache "";' >> /etc/apt/apt.conf.d/docker-clean; \
    \
# https://github.com/docker/docker/blob/9a9fc01af8fb5d98b8eec0740716226fadb3735c/contrib/mkimage/debootstrap#L109-L115
    echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/docker-no-languages; \
    \
# https://github.com/docker/docker/blob/9a9fc01af8fb5d98b8eec0740716226fadb3735c/contrib/mkimage/debootstrap#L118-L130
    echo 'Acquire::GzipIndexes "true"; Acquire::CompressionTypes::Order:: "gz";' > /etc/apt/apt.conf.d/docker-gzip-indexes; \
    \
# https://github.com/docker/docker/blob/9a9fc01af8fb5d98b8eec0740716226fadb3735c/contrib/mkimage/debootstrap#L134-L151
    echo 'Apt::AutoRemove::SuggestsImportant "false";' > /etc/apt/apt.conf.d/docker-autoremove-suggests
# add clang 9 repos
RUN apt-get update
RUN apt-get install -y curl apt-transport-https ca-certificates --no-install-recommends && rm -rf /var/lib/apt/lists/*;
RUN echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-9 main" >> /etc/apt/sources.list
RUN echo "deb http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu xenial main" >> /etc/apt/sources.list
RUN curl -f https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 60C317803A41BA51845E371A1E9377A2BA9EF27F
RUN apt-get update
RUN apt-get -y install g++-7 clang-9 clang-tools-9 --no-install-recommends && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --install /usr/bin/cc cc   /usr/bin/clang-9  50
RUN update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-9  50
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-9 50
RUN update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-9 50
# install R dependencies
RUN apt-get -y --no-install-recommends install libxml2-dev libssl-dev libcairo2-dev patch curl libcurl4-gnutls-dev make gfortran git unzip libreadline-dev libicu-dev libpcre2-dev && rm -rf /var/lib/apt/lists/*;
# delete all the apt list files since they're big and get stale quickly
RUN rm -rf /var/lib/apt/lists/*
# this forces "apt-get update" in dependent images, which is also good
# (see also https://bugs.launchpad.net/cloud-images/+bug/1699913)
# make systemd-detect-virt return "docker"
# See: https://github.com/systemd/systemd/blob/aa0c34279ee40bce2f9681b496922dedbadfca19/src/basic/virt.c#L434
RUN mkdir -p /run/systemd && echo 'docker' > /run/systemd/container

CMD ["/bin/bash"]
