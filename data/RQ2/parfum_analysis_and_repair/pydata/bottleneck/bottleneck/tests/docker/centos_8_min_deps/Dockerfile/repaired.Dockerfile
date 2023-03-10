FROM centos:8
RUN yum update -y
RUN yum install -y gcc python3-devel python3-pip && rm -rf /var/cache/yum
RUN pip3 install --no-cache-dir --upgrade pip
WORKDIR /tmp
CMD ["pip3", "install", "/bottleneck_src"]