from amazonlinux:latest
MAINTAINER cb-developer-network@vmware.com

COPY . /app
WORKDIR /app

RUN yum -y install python3-devel && rm -rf /var/cache/yum
RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir .
