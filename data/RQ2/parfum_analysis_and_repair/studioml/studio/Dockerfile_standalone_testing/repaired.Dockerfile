FROM ubuntu:16.04

MAINTAINER jiamingjxu@gmail.com

ENV LANG C.UTF-8

RUN mkdir -p /setupTesting

COPY . /setupTesting

WORKDIR /setupTesting

RUN apt-get update && apt-get install --no-install-recommends -y \
curl && rm -rf /var/lib/apt/lists/*;

RUN \
    apt-get update && apt-get install --no-install-recommends -y apt-transport-https && \
    curl -f -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y kubectl && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
	apt-get install --no-install-recommends -y python-pip libpq-dev python-dev && \
	apt-get install --no-install-recommends -y git && \
	pip install --no-cache-dir -U pytest && \
	pip install --no-cache-dir -r test_requirements.txt && \
	python setup.py build && \
	python setup.py install && rm -rf /var/lib/apt/lists/*;

CMD python -m pytest tests/util_test.py
