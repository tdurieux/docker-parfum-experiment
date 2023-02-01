FROM ubuntu:14.04

RUN apt-get update -y && apt-get install --no-install-recommends -y -q \
        build-essential \
        libpq-dev \
        python \
        python-dev \
        python-pip \
        libjpeg-dev \
    && apt-get clean \
    && apt-get autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ && rm -rf /var/lib/apt/lists/*;

WORKDIR /src/
ADD . /src/

RUN pip install --no-cache-dir pytest pytest-cov pytest-pep8 pytest-flakes
RUN pip install --no-cache-dir -e .[develop]

CMD ["python"]
