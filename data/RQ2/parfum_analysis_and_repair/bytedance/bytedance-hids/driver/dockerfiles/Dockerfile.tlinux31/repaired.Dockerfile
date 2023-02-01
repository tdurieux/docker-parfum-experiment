FROM tencentos/tencentos_server31:latest AS tlinux31
CMD [ "sh", "-c", "echo start" ]

RUN yum install -y wget perl gcc make tree elfutils-libelf-devel; rm -rf /var/cache/yum
RUN yum groupinstall -y  "Development Tools";

RUN mkdir /root/headers
RUN for each_tag in `dnf --showduplicates list kernel-devel | grep kernel-devel | awk -c '{print $2}'`; do dnf -y install --downloadonly --downloaddir=/root/headers kernel-devel-$each_tag.x86_64; done
RUN rpm --force -i /root/headers/*.rpm

ADD . /elkeid
WORKDIR /elkeid/driver
RUN bash ./batch_compile.sh