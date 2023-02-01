FROM cern/c8-base:latest AS rhel8

RUN yum install -y wget perl gcc make tree elfutils-libelf-devel; rm -rf /var/cache/yum
RUN yum groupinstall -y  "Development Tools";
RUN mkdir /root/headers

RUN cd /tmp; \
wget -q -c -r -np -nd -nH -A 'kernel-devel*x86_64.rpm' 'https://mirrors.nju.edu.cn/cc/8.0/BaseOS/x86_64/os/Packages/'; \
wget -q -c -r -np -nd -nH -A 'kernel-devel*x86_64.rpm' 'https://mirrors.nju.edu.cn/cc/8.1/BaseOS/x86_64/os/Packages/'; \
wget -q -c -r -np -nd -nH -A 'kernel-devel*x86_64.rpm' 'https://mirrors.nju.edu.cn/cc/8.2/BaseOS/x86_64/os/Packages/'; \
wget -q -c -r -np -nd -nH -A 'kernel-devel*x86_64.rpm' 'https://mirrors.nju.edu.cn/cc/8.3/BaseOS/x86_64/os/Packages/';  \
wget -q -c -r -np -nd -nH -A 'kernel-devel*x86_64.rpm' 'https://mirrors.nju.edu.cn/cc/8.4/BaseOS/x86_64/os/Packages/';  \
wget -q -c -r -np -nd -nH -A 'kernel-devel*x86_64.rpm' 'https://mirrors.nju.edu.cn/cc/8.5/BaseOS/x86_64/os/Packages/';
RUN rpm -ivh /tmp/*.rpm || true

ADD . /elkeid
WORKDIR /elkeid/driver
RUN bash ./batch_compile.sh

