FROM amazonlinux:2018.03.0.20180424


WORKDIR /workdir
COPY requirements.txt ./
RUN yum install -y gcc python36 python36-devel && rm -rf /var/cache/yum

ENTRYPOINT ["pip-3.6", "install", "-r", "requirements.txt", "-t", "./vendor-package"]
