FROM centos:6.6

WORKDIR /build

COPY Makefile.libgmp /build/Makefile

RUN yum install -y git autoconf curl nss gcc make tar bzip2 && rm -rf /var/cache/yum

CMD ["make", "install"]
