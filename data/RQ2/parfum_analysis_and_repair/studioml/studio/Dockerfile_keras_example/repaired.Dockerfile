FROM ubuntu:16.04

MAINTAINER jiamingjxu@gmail.com

ENV LANG C.UTF-8

RUN mkdir -p /setupTesting

COPY . /setupTesting

WORKDIR /setupTesting

RUN apt-get update && \
	apt-get install --no-install-recommends -y python-pip libpq-dev python-dev && \
	apt-get install --no-install-recommends -y git && \
	pip install --no-cache-dir -U pytest && \
	pip install --no-cache-dir -r test_requirements.txt && \
	python setup.py build && \
	python setup.py install && rm -rf /var/lib/apt/lists/*;

CMD studio run --lifetime=30m --max-duration=20m --gpus 4 --queue=rmq_kmutch --force-git /examples/keras/train_mnist_keras.py