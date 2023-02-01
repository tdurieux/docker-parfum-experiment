FROM src
RUN yum update -y && yum install -y python3 python3-pip && rm -rf /var/cache/yum
RUN pip3 install --no-cache-dir pre-commit
