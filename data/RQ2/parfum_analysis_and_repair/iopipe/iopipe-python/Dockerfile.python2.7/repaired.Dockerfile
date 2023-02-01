FROM lambci/lambda:build-python2.7

RUN yum -y install mysql-devel && rm -rf /var/cache/yum
RUN pip install --no-cache-dir -U pip setuptools

RUN mkdir -p /var/lib/iopipe

WORKDIR /var/lib/iopipe

COPY . /var/lib/iopipe

RUN python setup.py test
