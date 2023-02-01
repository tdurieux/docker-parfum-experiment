FROM gluster/gluster-centos:latest
MAINTAINER Jin Li <jinlmsft@hotmail.com>
# Need to revise python setup so that it won't break glusterfs dependency
#

# Install python package
# Warning: Be careful of package/python version added here. Upgrade python or package may break glusterfs

RUN curl -f "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
RUN python get-pip.py
RUN pip install --no-cache-dir pyyaml jinja2 argparse
RUN yum install -y attr && rm -rf /var/cache/yum

WORKDIR /opt/glusterfs
ADD launch_glusterfs.py /opt/glusterfs/
ADD glusterfs_config.yaml /opt/glusterfs/
ADD logging.yaml /opt/glusterfs/
ADD glusterfs-mount.service /usr/lib/systemd/system/glusterfs-mount.service
RUN chmod +x /opt/glusterfs/launch_glusterfs.py

RUN systemctl enable glusterfs-mount.service
RUN systemctl enable nfs-server.service

RUN sed -i 's_# Lock=True_Lock=False_' /etc/nfsmount.conf

# All process in this docker needs to be run as a service.
# Do not change the command, rewrite a service if need to

CMD /usr/sbin/init








