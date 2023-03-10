FROM centos:7
RUN yum install -q -y git rpm-build rpm-devel rpmlint make python rpmdevtools help2man \
        redhat-lsb-core \
    && groupadd -g 1004 builduser \
    && useradd -m -u 1003 -g builduser builduser && rm -rf /var/cache/yum

USER builduser
RUN mkdir /home/builduser/configsnap \
    && rpmdev-setuptree
WORKDIR /home/builduser/configsnap
CMD ["make","rpm"]
