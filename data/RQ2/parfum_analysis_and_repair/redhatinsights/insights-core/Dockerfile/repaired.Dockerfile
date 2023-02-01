FROM centos:7
RUN yum install -y python-devel file zip gcc libffi-devel && yum clean all && rm -rf /var/cache/yum
RUN curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python get-pip.py && rm get-pip.py
COPY . /src
RUN pip install --no-cache-dir /src
