FROM adoptopenjdk/openjdk8:centos

RUN yum install -y python3 postgresql-devel python3-devel.x86_64 make automake gcc gcc-c++ kernel-devel && rm -rf /var/cache/yum
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --upgrade pip setuptools
RUN pip3 install --no-cache-dir setuptools_rust wheel
RUN pip3 install --no-cache-dir dbt==0.20.0
