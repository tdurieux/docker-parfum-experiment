FROM python:3.5-alpine

ADD . /tmp/concrete-python
WORKDIR /tmp/concrete-python
RUN pip install --no-cache-dir tox
RUN python setup.py install
