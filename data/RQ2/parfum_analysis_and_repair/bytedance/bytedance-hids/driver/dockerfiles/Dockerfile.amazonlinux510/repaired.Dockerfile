FROM amazonlinux:2 AS amzn2v510
RUN amazon-linux-extras enable kernel-5.10
RUN yum update -y && yum install -y initscripts; rm -rf /var/cache/yum
RUN yum install -y gcc make git || true && rm -rf /var/cache/yum
RUN yum install -y kernel-headers dkms || true && rm -rf /var/cache/yum
RUN for eachversion in `yum --showduplicates list available kernel-devel | grep kernel-devel.x86_64 | grep "5.10" | awk '{print $2}'`; do yum install -y --downloadonly --downloaddir=/root kernel-devel-$eachversion.x86_64 || true; done; rm -rf /var/cache/yum

RUN yum clean all
RUN rm -rf /var/cache/yum/*
RUN rpm -i --nodeps --force /root/kernel-devel-*amzn2.x86_64.rpm
RUN rm -f  /root/kernel-devel-*amzn2.x86_64.rpm

ADD . /elkeid
WORKDIR /elkeid/driver
RUN bash ./batch_compile.sh