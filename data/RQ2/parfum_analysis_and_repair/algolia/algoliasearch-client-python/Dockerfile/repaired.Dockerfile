# Dockerfile
FROM python:3.8.2

WORKDIR /algoliasearch
ADD . /algoliasearch/

# install dev env dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt
# setup dev env

RUN python3 setup.py install