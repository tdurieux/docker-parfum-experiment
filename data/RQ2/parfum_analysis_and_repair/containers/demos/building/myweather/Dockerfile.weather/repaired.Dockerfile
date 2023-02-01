FROM quay.io/buildah/stable
RUN yum install -y python3 python-pip && rm -rf /var/cache/yum
RUN pip3 install --no-cache-dir requests
COPY weather.py /
CMD  python3 weather.py
