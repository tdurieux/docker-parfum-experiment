FROM ubuntu:18.04
RUN sed -i 's:^path-exclude=/usr/share/man:#path-exclude=/usr/share/man:' \
        /etc/dpkg/dpkg.cfg.d/excludes
RUN sed -i 's/archive.ubuntu.com/ftp.sjtu.edu.cn/g' /etc/apt/sources.list
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    g++ \
    man \
    manpages-posix \
    vim && rm -rf /var/lib/apt/lists/*;
RUN echo "root:root" | chpasswd
RUN useradd -rm -d /home/ve280-demo -s /bin/bash -g root -G sudo -u 1000 ve280-demo
USER ve280-demo
WORKDIR /home/ve280-demo
