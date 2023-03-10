ARG OS_FULLPATH
FROM $OS_FULLPATH

RUN apt update && apt-get install -y --no-install-recommends \
        dnsutils \
        iputils-ping \
        python3 \
        python3-pip \
        python3-setuptools \
        vim && rm -rf /var/lib/apt/lists/*;

WORKDIR /

ARG NHD_VERSION

COPY ./dist/nhd-$NHD_VERSION-py3-none-any.whl /
RUN pip3 install --no-cache-dir wheel
RUN pip3 install --no-cache-dir /nhd-$NHD_VERSION-py3-none-any.whl
COPY deploy/requirements.txt /
RUN pip3 install --no-cache-dir -r /requirements.txt

RUN chmod 777 /usr/local/bin/nhd

CMD ["/usr/local/bin/nhd"]
#CMD ["/bin/bash"]
