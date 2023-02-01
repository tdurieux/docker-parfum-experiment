FROM python:2.7-alpine
# Dockerfile to run tests under python2.7

# docker build -t ipaddress-python2.7 . -f test-python2.7.Dockerfile
RUN apk add --no-cache make
RUN pip install --no-cache-dir flake8

ADD . .
RUN python test_ipaddress.py
RUN make lint
CMD python test_ipaddress.py
