FROM centos:7

RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y make mock python3 which git gcc python3-devel && rm -rf /var/cache/yum

# Fix output of rpm --eval '%{?dist}'
RUN sed -i "s/.el7.centos/.el7/g" /etc/rpm/macros.dist

RUN pip3 install --no-cache-dir -IU poetry ansible dephell[full]
