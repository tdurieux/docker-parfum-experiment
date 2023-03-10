FROM debian:wheezy-20190228

ARG go_pkg_url

RUN echo "deb http://archive.debian.org/debian/ wheezy contrib main non-free" > /etc/apt/sources.list && \
    echo "deb-src http://archive.debian.org/debian/ wheezy contrib main non-free" >> /etc/apt/sources.list && \
    apt-get update && apt-get install --no-install-recommends -y apt-utils && \
    apt-get install --no-install-recommends -y --force-yes \
    curl gcc make sudo expect gnupg fakeroot perl-base=5.14.2-21+deb7u3 perl \
    libc-bin=2.13-38+deb7u10 libc6=2.13-38+deb7u10 libc6-dev build-essential \
    cdbs devscripts equivs automake autoconf libtool libaudit-dev selinux-basics \
    libdb5.1=5.1.29-5 libdb5.1-dev libssl1.0.0=1.0.1e-2+deb7u20 procps gawk libsigsegv2 \
    curl ca-certificates devscripts && rm -rf /var/lib/apt/lists/*;

RUN curl -f -s -k $go_pkg_url -o go.tar.gz && \
    tar -C /usr/local -xzf go.tar.gz && \
    rm go.tar.gz

RUN groupadd -g 1000 jenkins-build && useradd -u 1000 -g 1000 jenkins-build
RUN chmod 777 /home

CMD ["/usr/bin/sshd", "-D"]

