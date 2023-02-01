FROM amazonlinux
RUN yum install -y python36 && rm -rf /var/cache/yum
RUN yum install -y findutils which wget && rm -rf /var/cache/yum

RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py

WORKDIR /opt

