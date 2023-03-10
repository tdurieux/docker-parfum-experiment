FROM debian:10

RUN echo "deb http://mirrors.163.com/debian/ buster main non-free contrib\n" \
         "deb http://mirrors.163.com/debian/ buster-updates main non-free contrib\n" \
         "deb http://mirrors.163.com/debian/ buster-backports main non-free contrib\n" \
         "deb http://mirrors.163.com/debian-security/ buster/updates main non-free contrib\n" \
         "deb-src http://mirrors.163.com/debian/ buster main non-free contrib\n" \
         "deb-src http://mirrors.163.com/debian/ buster-updates main non-free contrib\n" \
         "deb-src http://mirrors.163.com/debian/ buster-backports main non-free contrib\n" \
         "deb-src http://mirrors.163.com/debian-security/ buster/updates main non-free contrib\n" \
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
        fuse3 \
        libnl-3-200 \
        libnl-genl-3-200 \
        libjemalloc2 \
    && ln -s /usr/lib/x86_64-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && rm -rf /var/lib/apt/lists/*;

COPY libetcdclient.so /usr/lib/