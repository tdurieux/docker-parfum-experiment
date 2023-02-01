FROM ubuntu:17.10

ENV BASE_OS_IMAGE=ubuntu

ENV LC_ALL=C.UTF-8

ENV LANG=C.UTF-8

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get install --no-install-recommends -y \
        ca-certificates \
        build-essential \
        python-lxml \
        python-dev \
        python-setuptools \
        python-pip && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir -r /tmp/requirements.txt

COPY . /root/sdist

RUN cd /root/sdist && \
    python setup.py install && \
    cd /root && \
    rm -rf sdist

ENTRYPOINT ["canari"]
