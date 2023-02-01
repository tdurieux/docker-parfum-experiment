FROM python:3.10
RUN pip3 install --no-cache-dir cython pip setuptools --upgrade

WORKDIR /code
