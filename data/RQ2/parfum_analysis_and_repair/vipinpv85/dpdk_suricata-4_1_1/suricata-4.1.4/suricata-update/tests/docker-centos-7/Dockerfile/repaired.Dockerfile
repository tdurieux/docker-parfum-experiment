FROM centos:7

RUN yum -y install epel-release && rm -rf /var/cache/yum
RUN yum -y install \
    git \
    python-yaml \
    python-pip \
    pytest \
    python34-yaml \
    python34-pytest \
    python34-pip \
    findutils && rm -rf /var/cache/yum

COPY / /src
RUN find /src -name \*.pyc -delete

ENV PYTEST2 py.test
ENV PYTEST3 py.test-3

ENV PIP2 pip2
ENV PIP3 pip3

WORKDIR /src

CMD ["./tests/docker-centos-7/run.sh"]
