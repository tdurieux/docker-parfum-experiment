FROM centos:8.2.2004

LABEL maintainer="Shirong Hao <shirong@linux.alibaba.com>"

RUN yum -y install yum-utils wget iptables protobuf-c && rm -rf /var/cache/yum

# install docker
RUN dnf --enablerepo=PowerTools install -y iptables && \
    wget https://download.docker.com/linux/static/stable/x86_64/docker-19.03.8.tgz && \
    tar -zxvf docker-19.03.8.tgz && mv docker/* /usr/bin && rm -rf docker && rm -f docker-19.03.8.tgz

# configure the rune runtime of docker
RUN mkdir -p /etc/docker && \
    echo -e "{\n\t\"runtimes\": {\n\t\t\"rune\": {\n\t\t\t\"path\": \"/usr/local/bin/rune\",\n\t\t\t\"runtimeArgs\": []\n\t\t}\n\t}\n}" >> /etc/docker/daemon.json

RUN wget -c https://download.01.org/intel-sgx/latest/linux-latest/distro/centos8.2-server/sgx_rpm_local_repo.tgz && \
    tar xzf sgx_rpm_local_repo.tgz && \
    yum-config-manager --add-repo sgx_rpm_local_repo && \
    yum makecache && yum install --nogpgcheck -y libsgx-dcap-quote-verify libsgx-dcap-default-qpl libsgx-epid && \
    rm -f sgx_rpm_local_repo.tgz && rm -rf /var/cache/yum

WORKDIR /root
