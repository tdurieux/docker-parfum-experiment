FROM fedora:23
RUN yum install -y python python-pip git sudo && rm -rf /var/cache/yum
COPY tests.sh /tmp/tests.sh
CMD bash /tmp/tests.sh
