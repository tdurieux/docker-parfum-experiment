FROM centos:7

RUN yum update -y && yum install rpm-build make python-setuptools -y && rm -rf /var/cache/yum
RUN curl -f "https://bootstrap.pypa.io/pip/2.7/get-pip.py" -o "get-pip.py"
RUN python get-pip.py

COPY ./build-rpm.py /build-rpm.py
ENTRYPOINT ["python", "/build-rpm.py"]
CMD ["/var/wdir"]
