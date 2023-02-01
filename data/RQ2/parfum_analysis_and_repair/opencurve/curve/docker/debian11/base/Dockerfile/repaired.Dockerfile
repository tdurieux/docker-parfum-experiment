FROM debian:11

RUN echo "deb http://mirrors.163.com/debian/ bullseye main non-free contrib\n" \
         "deb http://mirrors.163.com/debian/ bullseye-updates main non-free contrib\n" \
         "deb http://mirrors.163.com/debian/ bullseye-backports main non-free contrib\n" \
         "deb http://mirrors.163.com/debian-security/ stable-security main non-free contrib\n" \
         "deb-src http://mirrors.163.com/debian/ bullseye main non-free contrib\n" \
         "deb-src http://mirrors.163.com/debian/ bullseye-updates main non-free contrib\n" \
         "deb-src http://mirrors.163.com/debian/ bullseye-backports main non-free contrib\n" \
         "deb-src http://mirrors.163.com/debian-security/ stable-security main non-free contrib\n" \
    > /etc/apt/sources.list \
    && apt-get clean \
    && apt-get -y update \
    && apt-get -y --no-install-recommends install \
        gcc \
        gdb \
        make \
        openssl \
        net-tools \
        libcurl3-gnutls \
        perl \
        linux-perf \
        vim \
        curl \
        cron \
        procps \
        lsof \
        nginx \
        less \
        fuse \
        libnl-3-200 \
        libnl-genl-3-200 \
        libjemalloc2 && rm -rf /var/lib/apt/lists/*;

COPY libetcdclient.so /usr/lib/