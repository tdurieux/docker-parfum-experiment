FROM tencentos/tencentos_server24:latest AS tlinux24
CMD [ "sh", "-c", "echo start" ]

RUN yum install -y wget perl gcc make tree elfutils-libelf-devel yumdownloader; rm -rf /var/cache/yum
RUN yum groupinstall -y  "Development Tools";
RUN mkdir /root/headers
RUN for each_tag in `yum --showduplicates list kernel-devel | grep kernel-devel | awk -c '{print $2}'`; do yumdownloader  --destdir /root/headers kernel-devel-$each_tag.x86_64; done
RUN rpm --force -ivh /root/headers/*.rpm || true

ADD . /elkeid
WORKDIR /elkeid/driver
RUN bash ./batch_compile.sh