FROM ubuntu:xenial

WORKDIR /opt
RUN apt-get update
RUN apt-get install --no-install-recommends -y tar git curl nano wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential libssl-dev libffi-dev python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip python3-setuptools && rm -rf /var/lib/apt/lists/*;
RUN apt-get update

RUN mkdir /tmp/Python3.7
WORKDIR /tmp/Python3.7
RUN wget https://www.python.org/ftp/python/3.7.2/Python-3.7.2.tar.xz
RUN tar xvf Python-3.7.2.tar.xz && rm Python-3.7.2.tar.xz

WORKDIR /tmp/Python3.7/Python-3.7.2
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-optimizations
RUN make altinstall

WORKDIR /opt
COPY requirements.txt /opt/requirements.txt
RUN pip3.7 install -r requirements.txt

COPY api /opt/api
COPY config.ini /opt/config.ini
COPY server.py /opt/server.py

HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD curl --fail http://0.0.0.0:8080/api/v1/parser/healthcheck || exit 1

RUN mkdir /root/.postgresql
COPY ./.postgresql/ca-certificate.crt /root/.postgresql/root.crt

EXPOSE 8080
