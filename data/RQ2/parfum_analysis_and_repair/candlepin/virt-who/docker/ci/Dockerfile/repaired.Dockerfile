FROM ubuntu:trusty
MAINTAINER Radek Novacek <rnovacek@redhat.com>
RUN apt-get update && \
    apt-get upgrade -y python-requests && \
    apt-get install --no-install-recommends -y python python-pip python-pytest python-dev git libvirt0 swig libvirt-dev libssl-dev && \
    pip install --no-cache-dir -U iniparse python-dateutil M2Crypto libvirt-python unittest2 pytest-timeout mock && rm -rf /var/lib/apt/lists/*;
COPY . /virt-who
RUN pip install --no-cache-dir -r /virt-who/requirements.txt
WORKDIR /virt-who
CMD PYTHONPATH=. py.test --timeout=30
