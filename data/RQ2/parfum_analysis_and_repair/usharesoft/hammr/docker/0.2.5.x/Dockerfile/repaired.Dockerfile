FROM centos:7
RUN yum install -y wget gcc python-devel libxml2-devel libxslt-devel && rm -rf /var/cache/yum
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py
RUN pip install --no-cache-dir "hammr>=0.2.5,<0.2.6"
ADD overlay /
