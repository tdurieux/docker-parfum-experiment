FROM centos:8
MAINTAINER linyows <linyows@gmail.com>

RUN yum install -y gcc make libcurl-devel jansson-devel bzip2 unzip rpmdevtools epel-release selinux-policy-devel && rm -rf /var/cache/yum
# For epel
RUN yum install -y clang && rm -rf /var/cache/yum

RUN mkdir -p /root/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
RUN sed -i "s;%_build_name_fmt.*;%_build_name_fmt\t%%{ARCH}/%%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.el8.rpm;" /usr/lib/rpm/macros

RUN mkdir /octopass
WORKDIR /octopass
