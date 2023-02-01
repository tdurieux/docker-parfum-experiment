FROM centos

RUN yum update -y && yum install -y make automake libtool openssl-devel curl && rm -rf /var/cache/yum
RUN yum install -y lapack-devel atlas-devel gcc-c++ python-devel && rm -rf /var/cache/yum

RUN curl -f -O https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py

RUN pip install --no-cache-dir https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.5.0-cp27-none-linux_x86_64.whl

RUN yum clean all
