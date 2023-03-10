FROM python:2.7-slim

RUN mkdir -p /opt
RUN apt-get update && apt-get install -y --no-install-recommends curl pandoc && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-17.04.0-ce.tgz \
  && tar xzvf docker-17.04.0-ce.tgz \
  && mv docker/docker /usr/local/bin \
  && rm -r docker docker-17.04.0-ce.tgz
ADD . /opt/py-cloud-compute-cannon
WORKDIR /opt/py-cloud-compute-cannon
RUN pandoc --from=markdown --output=README.rst --to=rst README.md
RUN python setup.py sdist && pip install --no-cache-dir dist/*
RUN pip install --no-cache-dir -r /opt/py-cloud-compute-cannon/pyccc/tests/requirements.txt