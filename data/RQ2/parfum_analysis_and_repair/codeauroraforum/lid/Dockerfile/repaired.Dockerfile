FROM ubuntu:18.04

MAINTAINER Craig Northway

RUN apt-get update && apt-get install --no-install-recommends -y python python-pip python3.6 python3-distutils git && pip install --no-cache-dir -U setuptools==25.2.0 && pip install --no-cache-dir tox && pip install --no-cache-dir pyyaml && pip install --no-cache-dir chardet && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && add-apt-repository -y ppa:pypy/ppa && apt-get update && apt-get install --no-install-recommends -y pypy3 && rm -rf /var/lib/apt/lists/*;

COPY . /src

CMD cd /src && tox -r
