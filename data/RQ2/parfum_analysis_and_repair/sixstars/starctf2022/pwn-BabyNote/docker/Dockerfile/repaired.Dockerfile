FROM ubuntu:20.04
RUN sed -i "s/http:\/\/archive.ubuntu.com/http:\/\/mirrors.ustc.edu.cn/g" /etc/apt/sources.list
RUN apt-get update && apt-get -y upgrade
RUN apt-get install --no-install-recommends -y lib32z1 xinetd && rm -rf /var/lib/apt/lists/*;
copy musl_1.2.2-1_amd64.deb /musl_1.2.2-1_amd64.deb
RUN dpkg -i /musl_1.2.2-1_amd64.deb
RUN useradd -u 8888 -m pwn
CMD ["/usr/sbin/xinetd", "-dontfork"]
