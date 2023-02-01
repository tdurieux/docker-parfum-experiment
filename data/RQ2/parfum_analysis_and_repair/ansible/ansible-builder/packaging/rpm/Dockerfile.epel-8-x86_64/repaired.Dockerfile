FROM centos:8

RUN dnf install -y epel-release
RUN yum install -y make mock python3-pip which git gcc python3-devel && rm -rf /var/cache/yum

RUN pip3 install --no-cache-dir -IU poetry ansible dephell[full]
