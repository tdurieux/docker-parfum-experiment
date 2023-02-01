FROM centos:7
LABEL maintainer="package@datadoghq.com"

# preparation for saltstack
RUN yum -y update && yum -y install curl && rm -rf /var/cache/yum

# enable systemd, thanks to @gdraheim (https://github.com/gdraheim/)
ADD utils/systemctl.py /usr/bin/systemctl
ADD utils/systemctl.py /usr/bin/systemd

# install salt
RUN curl -f -L https://bootstrap.saltstack.com | sh -s -- -d -X stable; exit 0

# add the start test script
ADD start.sh /start.sh
CMD ["bash", "start.sh"]
