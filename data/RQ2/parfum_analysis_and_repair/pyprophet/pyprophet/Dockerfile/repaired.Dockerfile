# PyProphet Dockerfile
FROM python:3.9.1

# install numpy & cython
RUN pip install --no-cache-dir numpy cython

# install PyProphet and dependencies
ADD . /pyprophet
WORKDIR /pyprophet
RUN python setup.py install
WORKDIR /
RUN rm -rf /pyprophet
