FROM python:2.7.15-slim-stretch as base
WORKDIR /code
ADD . .
RUN cp flatc_debian_stretch flatc
WORKDIR /code/tests
RUN python --version
RUN pip install --no-cache-dir coverage
RUN ./PythonTest.sh
