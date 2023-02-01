FROM centos/systemd

ARG FPM_VERSION=1.11.0
ARG PYTHON_VERSION=3
ARG DOCKER_WORKDIR=/usr/share/pdagent-integrations
ENV PYTHON_VERSION ${PYTHON_VERSION}
ENV container docker
ENV DOCKER_WORKDIR ${DOCKER_WORKDIR}

RUN yum install -y -q centos-release-scl && rm -rf /var/cache/yum
RUN yum install -y -q createrepo && rm -rf /var/cache/yum
RUN yum install -y -q gcc && rm -rf /var/cache/yum
RUN yum install -y -q gcc-c++ && rm -rf /var/cache/yum
RUN yum install -y -q kernel-devel && rm -rf /var/cache/yum
RUN yum install -y -q make && rm -rf /var/cache/yum
RUN yum install -y -q python27-python-pip && rm -rf /var/cache/yum
RUN yum install -y -q python3-pip && rm -rf /var/cache/yum
RUN yum install -y -q rpm-build && rm -rf /var/cache/yum
RUN yum install -y -q rpm-sign && rm -rf /var/cache/yum
RUN yum install -y -q rh-ruby23 && rm -rf /var/cache/yum
RUN yum install -y -q rh-ruby23-ruby-devel && rm -rf /var/cache/yum
RUN yum install -y -q sudo && rm -rf /var/cache/yum
RUN yum install -y -q which && rm -rf /var/cache/yum

RUN source /opt/rh/rh-ruby23/enable && \
  /opt/rh/rh-ruby23/root/usr/bin/gem install -q --no-ri --no-rdoc -v $FPM_VERSION fpm
RUN yum install -y python${PYTHON_VERSION} && rm -rf /var/cache/yum

COPY . $DOCKER_WORKDIR
WORKDIR $DOCKER_WORKDIR

CMD ["/usr/sbin/init"]
