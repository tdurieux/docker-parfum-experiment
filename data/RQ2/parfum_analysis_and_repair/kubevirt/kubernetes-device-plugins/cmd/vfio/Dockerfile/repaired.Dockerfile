FROM fedora:27

RUN yum -y install kmod && rm -rf /var/cache/yum

COPY vfio /vfio

CMD ["/vfio"]
