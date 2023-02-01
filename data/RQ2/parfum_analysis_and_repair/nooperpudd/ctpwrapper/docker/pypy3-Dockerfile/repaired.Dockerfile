FROM pypy:3.9
RUN pypy3 -m ensurepip
RUN pip3 install --no-cache-dir cython pip setuptools --upgrade
WORKDIR /code
