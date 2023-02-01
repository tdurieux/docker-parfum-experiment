FROM ubuntu:16.04

RUN apt-get update && echo "y" | apt-get install -y --no-install-recommends apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /etc/apt/sources.list.d/docker.list


RUN apt-get update && \
    echo "y" | apt-get install -y --no-install-recommends python \
    python-dev \
    python-pip \
    build-essential \
    docker-engine \
    dpkg \
    dpkg-dev \
    qemu-kvm \
  && pip install --no-cache-dir -I pip==9.0.1 \
  && pip install --no-cache-dir mock && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /requirements.txt
COPY requirements-test.txt /requirements-test.txt
RUN pip install --no-cache-dir -r requirements-test.txt

WORKDIR /crawler

COPY . /crawler

RUN (cd psvmi/psvmi; python setup.py build && python setup.py install)

COPY psvmi/maps maps
COPY psvmi/offsets offsets
COPY psvmi/header.h .

CMD (docker daemon --storage-driver=vfs  > ../docker.out 2>&1 &) && \
	sleep 5 && \
        flake8 --max-complexity 10 . && \
        pylint crawler || true && \
        python setup.py test --addopts '-s --cov=.'
