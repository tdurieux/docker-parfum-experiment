FROM @BASE@
RUN yum install -y libvirt && systemctl enable libvirtd && rm -rf /var/cache/yum
