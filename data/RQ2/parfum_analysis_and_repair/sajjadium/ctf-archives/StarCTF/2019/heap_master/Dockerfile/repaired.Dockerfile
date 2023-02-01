FROM ubuntu:16.04
RUN sed -i "s/http:\/\/archive.ubuntu.com/http:\/\/mirrors.ustc.edu.cn/g" /etc/apt/sources.list
RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get install --no-install-recommends -y lib32z1 xinetd timelimit && rm -rf /var/lib/apt/lists/*;
RUN useradd -u 8888 -m pwn
CMD ["/usr/sbin/xinetd","-dontfork"]
